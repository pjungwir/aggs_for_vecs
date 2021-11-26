Datum vec_to_weighted_mean_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_weighted_mean_transfn);

/**
 * Returns an of n elements,
 * which each element is the weighted mean of the values found in that position
 * from all input arrays. The second parameter is an array of weights.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_weighted_mean_transfn(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  Oid elemWeightTypeId;
  int16 elemTypeWidth;
  int16 elemWeightTypeWidth;
  bool elemTypeByValue;
  bool elemWeightTypeByValue;
  char elemTypeAlignmentCode;
  char elemWeightTypeAlignmentCode;
  int currentLength;
  int currentWeightLength;
  MemoryContext aggContext;
  VecArrayBuildState *state = NULL;
  ArrayType *currentArray;
  ArrayType *currentWeightArray;
  int arrayLength;
  int arrayLengthWeight;
  Datum *currentVals;
  Datum *currentWeightVals;
  bool *currentNulls;
  bool *currentWeightNulls;
  int i;
  float8 prevValue, prevWeight, currentValue, currentWeight, newWeight;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_weighted_mean_transfn called in non-aggregate context");
  }

  // PG_ARGISNULL tests for SQL NULL,
  // but after the first pass we can have a
  // value that is non-SQL-NULL but still is C NULL.
  if (!PG_ARGISNULL(0)) {
    state = (VecArrayBuildState *)PG_GETARG_POINTER(0);
  }

  if (PG_ARGISNULL(1) || PG_ARGISNULL(2)) {
    // just return the current state unchanged (possibly still NULL)
    PG_RETURN_POINTER(state);
  }
  currentArray = PG_GETARG_ARRAYTYPE_P(1);
  currentWeightArray = PG_GETARG_ARRAYTYPE_P(2);

  if (state == NULL) {
    // Since we have our first not-null argument
    // we can initialize the state to match its length.
    elemTypeId = ARR_ELEMTYPE(currentArray);
    if (elemTypeId != INT2OID &&
        elemTypeId != INT4OID &&
        elemTypeId != INT8OID &&
        elemTypeId != FLOAT4OID &&
        elemTypeId != FLOAT8OID) {
      ereport(ERROR, (errmsg("vec_to_weighted_mean first input must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION")));
    }
    elemWeightTypeId = ARR_ELEMTYPE(currentWeightArray);
    if (elemWeightTypeId != INT2OID &&
        elemWeightTypeId != INT4OID &&
        elemWeightTypeId != INT8OID &&
        elemWeightTypeId != FLOAT4OID &&
        elemWeightTypeId != FLOAT8OID) {
      ereport(ERROR, (errmsg("vec_to_weighted_mean weights input must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION")));
    }
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    if (ARR_NDIM(currentWeightArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required for weights")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    arrayLengthWeight = (ARR_DIMS(currentWeightArray))[0];
    if (arrayLength != arrayLengthWeight) {
      ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d for values vs %d for weights", arrayLength, arrayLengthWeight)));
    }
    // Just start with all NULLs and let the comparisons below replace them:
    state = initVecArrayResultWithNulls(elemTypeId, FLOAT8OID, aggContext, arrayLength);
  } else {
    elemTypeId = state->inputElementType;
    arrayLength = state->state.nelems;
    elemWeightTypeId = ARR_ELEMTYPE(currentWeightArray);
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  get_typlenbyvalalign(elemWeightTypeId, &elemWeightTypeWidth, &elemWeightTypeByValue, &elemWeightTypeAlignmentCode);
  deconstruct_array(currentWeightArray, elemWeightTypeId, elemWeightTypeWidth, elemWeightTypeByValue, elemWeightTypeAlignmentCode,
      &currentWeightVals, &currentWeightNulls, &currentWeightLength);
  if (currentWeightLength != arrayLength) {
    ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d vs %d for weights", arrayLength, currentLength)));
  }

  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i] || currentWeightNulls[i]) {
      // do nothing: nulls can't change the result.
    } else {
      switch (elemTypeId) {
        case INT2OID:   currentValue = DatumGetInt16(currentVals[i]);  break;
        case INT4OID:   currentValue = DatumGetInt32(currentVals[i]);  break;
        case INT8OID:   currentValue = DatumGetInt64(currentVals[i]);  break;
        case FLOAT4OID: currentValue = DatumGetFloat4(currentVals[i]); break;
        case FLOAT8OID: currentValue = DatumGetFloat8(currentVals[i]); break;
        default: elog(ERROR, "Unknown elemTypeId!");
      }
      switch (elemWeightTypeId) {
        case INT2OID:   currentWeight = DatumGetInt16(currentWeightVals[i]);  break;
        case INT4OID:   currentWeight = DatumGetInt32(currentWeightVals[i]);  break;
        case INT8OID:   currentWeight = DatumGetInt64(currentWeightVals[i]);  break;
        case FLOAT4OID: currentWeight = DatumGetFloat4(currentWeightVals[i]); break;
        case FLOAT8OID: currentWeight = DatumGetFloat8(currentWeightVals[i]); break;
        default: elog(ERROR, "Unknown elemTypeId!");
      }
      if (state->state.dnulls[i]) {
        state->state.dnulls[i] = false;
        state->vecvalues[i].f8 = currentValue;
        state->vectmpvalues[i].f8 = currentWeight;
      } else {
        prevValue = state->vecvalues[i].f8;
        prevWeight = state->vectmpvalues[i].f8;
        newWeight = prevWeight + currentWeight;
        if (!newWeight) {
          state->vecvalues[i].f8 = 0;
          state->vectmpvalues[i].f8 = 0;
        } else {
          state->vecvalues[i].f8 = (prevWeight * prevValue + currentWeight * currentValue) / newWeight;
          state->vectmpvalues[i].f8 = newWeight;
        }
      }
    }
  }
  PG_RETURN_POINTER(state);
}

Datum vec_to_weighted_mean_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_weighted_mean_finalfn);

Datum
vec_to_weighted_mean_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  VecArrayBuildState *state;
  int dims[1];
  int lbs[1];
  int i;

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (VecArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL)
    PG_RETURN_NULL();

  // Convert from our pgnums to Datums:
  for (i = 0; i < state->state.nelems; i++) {
    if (state->state.dnulls[i]) continue;
    state->state.dvalues[i] = Float8GetDatum(state->vecvalues[i].f8);
  }

  dims[0] = state->state.nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(&state->state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
