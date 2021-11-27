
// We store bookkeping stuff in the vectmpvalues of our state variable,
// so that we don't have to figure everything out every row.
// Here are some macros to make sure we access what we want
// the same way every time:
#define HIST_MD_DIMENSIONS(s)        (s)->vectmpvalues[0].i32
#define HIST_MD_VAL_LENGTH(s)        (s)->vectmpvalues[1].i32
#define HIST_MD_VAL_INDEX(s, dim)    (s)->vectmpvalues[2 + 4 * (dim) + 0].i32
#define HIST_MD_BUCKET_START(s, dim) (s)->vectmpvalues[2 + 4 * (dim) + 1]
#define HIST_MD_BUCKET_WIDTH(s, dim) (s)->vectmpvalues[2 + 4 * (dim) + 2]
#define HIST_MD_BUCKET_COUNT(s, dim) (s)->vectmpvalues[2 + 4 * (dim) + 3].i32

Datum hist_md_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(hist_md_transfn);

/**
 * Returns a 2-dimensional histogram as a 2-d array.
 *
 * by Paul A. Jungwirth
 */
Datum
hist_md_transfn(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth, intTypeWidth;
  bool elemTypeByValue, intTypeByValue;
  char elemTypeAlignmentCode, intTypeAlignmentCode;
  MemoryContext aggContext;
  VecArrayBuildState *state = NULL;
  int dimensions;
  ArrayType *valsArray, *indexesArray, *bucketStartsArray, *bucketWidthsArray, *bucketCountsArray;
  Datum *valVals, *indexVals, *bucketStartVals, *bucketWidthVals, *bucketCountVals;
  bool *valNulls, *indexNulls, *bucketStartNulls, *bucketWidthNulls, *bucketCountNulls;
  int valLength, indexLength, bucketStartLength, bucketWidthLength, bucketCountLength;
  int resultLength;
  int i;
  int resultPos, idx, b, skip;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "hist_md_transfn called in non-aggregate context");
  }

  if (PG_ARGISNULL(2)) elog(ERROR, "hist_md val_indexes can't be null");
  if (PG_ARGISNULL(3)) elog(ERROR, "hist_md bucket_starts can't be null");
  if (PG_ARGISNULL(4)) elog(ERROR, "hist_md bucket_widths can't be null");
  if (PG_ARGISNULL(5)) elog(ERROR, "hist_md bucket_counts can't be null");

  if (PG_ARGISNULL(0)) {
    indexesArray = PG_GETARG_ARRAYTYPE_P(2);
    bucketStartsArray = PG_GETARG_ARRAYTYPE_P(3);
    bucketWidthsArray = PG_GETARG_ARRAYTYPE_P(4);
    bucketCountsArray = PG_GETARG_ARRAYTYPE_P(5);

    if (ARR_NDIM(indexesArray) != 1) {
      elog(ERROR, "hist_md val_indexes must have 1 dimension");
    }
    if (ARR_NDIM(bucketStartsArray) != 1) {
      elog(ERROR, "hist_md bucket_starts must have 1 dimension");
    }
    if (ARR_NDIM(bucketWidthsArray) != 1) {
      elog(ERROR, "hist_md bucket_widths must have 1 dimension");
    }
    if (ARR_NDIM(bucketCountsArray) != 1) {
      elog(ERROR, "hist_md bucket_counts must have 1 dimension");
    }

    // Figure out the result dimensions:

    get_typlenbyvalalign(INT4OID, &intTypeWidth, &intTypeByValue, &intTypeAlignmentCode);
    deconstruct_array(indexesArray, INT4OID, intTypeWidth, intTypeByValue, intTypeAlignmentCode,
        &indexVals, &indexNulls, &indexLength);

    dimensions = indexLength;
    if (ARR_ELEMTYPE(bucketCountsArray) != INT4OID) {
      elog(ERROR, "hist_md bucket_counts must be array of INTEGER");
    }
    deconstruct_array(bucketCountsArray, INT4OID, intTypeWidth, intTypeByValue, intTypeAlignmentCode,
        &bucketCountVals, &bucketCountNulls, &bucketCountLength);

    if (bucketCountLength != dimensions) elog(ERROR, "hist_md bucket_counts must have one entry for each dimension");
    resultLength = 1;
    for (i = 0; i < dimensions; i++) {
      if (bucketCountNulls[i]) elog(ERROR, "bucket_counts can't contain NULLs");
      resultLength *= DatumGetInt32(bucketCountVals[i]);
    }

    elemTypeId = ARR_ELEMTYPE(bucketStartsArray);
    if (elemTypeId != INT2OID &&
        elemTypeId != INT4OID &&
        elemTypeId != INT8OID &&
        elemTypeId != FLOAT4OID &&
        elemTypeId != FLOAT8OID) {
      elog(ERROR, "hist_md vals must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION");
    }

    // make sure we have enough tmp space
    // for our bookkeeping:
    state = initVecArrayResultWithNulls(elemTypeId, INT4OID, aggContext, Max(resultLength, 1 + dimensions * 4));
    memset(state->state.dnulls, 0, state->state.alen * sizeof(bool));
    state->state.nelems = resultLength;
    HIST_MD_DIMENSIONS(state) = dimensions;
    // Can't initialize this until we get our first non-NULL row:
    HIST_MD_VAL_LENGTH(state) = -1;

    // Now put all the params into `state`
    // for easy access on future iterations:

    get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
    deconstruct_array(bucketStartsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
        &bucketStartVals, &bucketStartNulls, &bucketStartLength);
    deconstruct_array(bucketWidthsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
        &bucketWidthVals, &bucketWidthNulls, &bucketWidthLength);

    // if (indexLength != dimensions)       elog(ERROR, "hist_md val_indexes must have one entry for each dimension");
    if (bucketStartLength != dimensions) elog(ERROR, "hist_md bucket_starts must have one entry for each dimension");
    if (bucketWidthLength != dimensions) elog(ERROR, "hist_md bucket_widths must have one entry for each dimension");

    for (i = 0; i < dimensions; i++) {
      if (indexNulls[i])       elog(ERROR, "val_indexes can't contain NULLs");
      if (bucketStartNulls[i]) elog(ERROR, "bucket_starts can't contain NULLs");
      if (bucketWidthNulls[i]) elog(ERROR, "bucket_widths can't contain NULLs");

      // Postgres arrays are 1-indexed for users,
      // so we should behave the same way:
      HIST_MD_VAL_INDEX(state, i) = DatumGetInt32(indexVals[i]) - 1;
      HIST_MD_BUCKET_COUNT(state, i) = DatumGetInt32(bucketCountVals[i]);
      if (HIST_MD_VAL_INDEX(state, i) < 0) {
        elog(ERROR, "val_indexes must all be greater than 0");
      }
      switch (elemTypeId) {
        case INT2OID:
          HIST_MD_BUCKET_START(state, i).i16 = DatumGetInt16(bucketStartVals[i]);
          HIST_MD_BUCKET_WIDTH(state, i).i16 = DatumGetInt16(bucketWidthVals[i]);
          break;
        case INT4OID:
          HIST_MD_BUCKET_START(state, i).i32 = DatumGetInt32(bucketStartVals[i]);
          HIST_MD_BUCKET_WIDTH(state, i).i32 = DatumGetInt32(bucketWidthVals[i]);
          break;
        case INT8OID:
          HIST_MD_BUCKET_START(state, i).i64 = DatumGetInt64(bucketStartVals[i]);
          HIST_MD_BUCKET_WIDTH(state, i).i64 = DatumGetInt64(bucketWidthVals[i]);
          break;
        case FLOAT4OID:
          HIST_MD_BUCKET_START(state, i).f4 = DatumGetFloat4(bucketStartVals[i]);
          HIST_MD_BUCKET_WIDTH(state, i).f4 = DatumGetFloat4(bucketWidthVals[i]);
          break;
        case FLOAT8OID:
          HIST_MD_BUCKET_START(state, i).f8 = DatumGetFloat8(bucketStartVals[i]);
          HIST_MD_BUCKET_WIDTH(state, i).f8 = DatumGetFloat8(bucketWidthVals[i]);
          break;
      }
    }
  } else {
    state = (VecArrayBuildState *)PG_GETARG_POINTER(0);
    elemTypeId = state->inputElementType;
    get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  }

  // Nothing to change:
  // Note this has to come after we initialize `state`,
  // so that we can return an array of all zeros if we get a single NULL row.
  if (PG_ARGISNULL(1)) PG_RETURN_POINTER(state);

  valsArray = PG_GETARG_ARRAYTYPE_P(1);
  if (ARR_NDIM(valsArray) != 1) {
    elog(ERROR, "hist_md vals must have 1 dimension");
  }
  deconstruct_array(valsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &valVals, &valNulls, &valLength);

  if (HIST_MD_VAL_LENGTH(state) == -1) {
    HIST_MD_VAL_LENGTH(state) = valLength;
    for (i = 0; i < HIST_MD_DIMENSIONS(state); i++) {
      if (HIST_MD_VAL_INDEX(state, i) >= valLength) {
        elog(ERROR, "val_indexes must all be less than or equal to %d", valLength);
      }
    }
  } else if (HIST_MD_VAL_LENGTH(state) != valLength) {
    elog(ERROR, "hist_md val arrays must all be the same length");
  }

  resultPos = 0;
  skip = 1;
  for (i = 0; i < HIST_MD_DIMENSIONS(state); i++) {
    idx = HIST_MD_VAL_INDEX(state, i);

    // One of the values is null so we can't plot this row:
    if (valNulls[idx]) PG_RETURN_POINTER(state);
    
    switch (elemTypeId) {
      case INT2OID:
        b = (DatumGetInt16(valVals[idx]) - HIST_MD_BUCKET_START(state, i).i16) / HIST_MD_BUCKET_WIDTH(state, i).i16;
        break;
      case INT4OID:
        b = (DatumGetInt32(valVals[idx]) - HIST_MD_BUCKET_START(state, i).i32) / HIST_MD_BUCKET_WIDTH(state, i).i32;
        break;
      case INT8OID:
        b = (DatumGetInt64(valVals[idx]) - HIST_MD_BUCKET_START(state, i).i64) / HIST_MD_BUCKET_WIDTH(state, i).i64;
        break;
      case FLOAT4OID:
        b = (DatumGetFloat4(valVals[idx]) - HIST_MD_BUCKET_START(state, i).f4) / HIST_MD_BUCKET_WIDTH(state, i).f4;
        break;
      case FLOAT8OID:
        b = (DatumGetFloat8(valVals[idx]) - HIST_MD_BUCKET_START(state, i).f8) / HIST_MD_BUCKET_WIDTH(state, i).f8;
        break;
    }
    resultPos += b * skip;
    skip *= HIST_MD_BUCKET_COUNT(state, i);
  }
  state->veccounts[resultPos] += 1;

  PG_RETURN_POINTER(state);
}

Datum hist_md_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(hist_md_finalfn);

Datum
hist_md_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  VecArrayBuildState *state;
  MemoryContext aggContext;
  int *dims;
  int *lbs;     // Lower Bounds of each dimension
  int i;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "hist_md_transfn called in non-aggregate context");
  }

  state = PG_ARGISNULL(0) ? NULL : (VecArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL) PG_RETURN_NULL();

  for (i = 0; i < state->state.nelems; i++) {
    state->state.dvalues[i] = UInt32GetDatum(state->veccounts[i]);
  }

  dims = MemoryContextAlloc(aggContext, HIST_MD_DIMENSIONS(state) * sizeof(int));
  lbs  = MemoryContextAlloc(aggContext, HIST_MD_DIMENSIONS(state) * sizeof(int));

  for (i = 0; i < HIST_MD_DIMENSIONS(state); i++) {
    dims[i] = HIST_MD_BUCKET_COUNT(state, i);
    lbs[i] = 1;
  }

  result = makeMdArrayResult(&state->state, HIST_MD_DIMENSIONS(state), dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
