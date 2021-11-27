
Datum hist_2d_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(hist_2d_transfn);

/**
 * Returns a 2-dimensional histogram as a 2-d array.
 *
 * by Paul A. Jungwirth
 */
Datum
hist_2d_transfn(PG_FUNCTION_ARGS)
{
  Oid elemTypeId = get_fn_expr_argtype(fcinfo->flinfo, 1);
  MemoryContext aggContext;
  VecArrayBuildState *state = NULL;
  pgnum xVal, yVal;
  pgnum xStart, yStart;
  pgnum xBucketWidth, yBucketWidth;
  int xLength, yLength;
  int xPos, yPos;
  int arrayLength;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "hist_2d_transfn called in non-aggregate context");
  }

  if (PG_ARGISNULL(3)) elog(ERROR, "hist_2d x_bucket_start can't be null");
  if (PG_ARGISNULL(4)) elog(ERROR, "hist_2d y_bucket_start can't be null");
  if (PG_ARGISNULL(5)) elog(ERROR, "hist_2d x_bucket_width can't be null");
  if (PG_ARGISNULL(6)) elog(ERROR, "hist_2d y_bucket_width can't be null");
  if (PG_ARGISNULL(7)) elog(ERROR, "hist_2d x_bucket_count can't be null");
  if (PG_ARGISNULL(8)) elog(ERROR, "hist_2d y_bucket_count can't be null");

  if (!OidIsValid(elemTypeId)) elog(ERROR, "could not determine data type of input");
  switch (elemTypeId) {
    case INT2OID:
      xVal.i16 = PG_GETARG_INT16(1);
      yVal.i16 = PG_GETARG_INT16(2);
      xStart.i16 = PG_GETARG_INT16(3);
      yStart.i16 = PG_GETARG_INT16(4);
      xBucketWidth.i16 = PG_GETARG_INT16(5);
      yBucketWidth.i16 = PG_GETARG_INT16(6);
      if (xBucketWidth.i16 <= 0) elog(ERROR, "hist_2d x_bucket_width must be greater than zero");
      if (yBucketWidth.i16 <= 0) elog(ERROR, "hist_2d y_bucket_width must be greater than zero");
      break;
    case INT4OID:
      xVal.i32 = PG_GETARG_INT32(1);
      yVal.i32 = PG_GETARG_INT32(2);
      xStart.i32 = PG_GETARG_INT32(3);
      yStart.i32 = PG_GETARG_INT32(4);
      xBucketWidth.i32 = PG_GETARG_INT32(5);
      yBucketWidth.i32 = PG_GETARG_INT32(6);
      if (xBucketWidth.i32 <= 0) elog(ERROR, "hist_2d x_bucket_width must be greater than zero");
      if (yBucketWidth.i32 <= 0) elog(ERROR, "hist_2d y_bucket_width must be greater than zero");
      break;
    case INT8OID:
      xVal.i64 = PG_GETARG_INT64(1);
      yVal.i64 = PG_GETARG_INT64(2);
      xStart.i64 = PG_GETARG_INT64(3);
      yStart.i64 = PG_GETARG_INT64(4);
      xBucketWidth.i64 = PG_GETARG_INT64(5);
      yBucketWidth.i64 = PG_GETARG_INT64(6);
      if (xBucketWidth.i64 <= 0) elog(ERROR, "hist_2d x_bucket_width must be greater than zero");
      if (yBucketWidth.i64 <= 0) elog(ERROR, "hist_2d y_bucket_width must be greater than zero");
      break;
    case FLOAT4OID:
      xVal.f4 = PG_GETARG_FLOAT4(1);
      yVal.f4 = PG_GETARG_FLOAT4(2);
      xStart.f4 = PG_GETARG_FLOAT4(3);
      yStart.f4 = PG_GETARG_FLOAT4(4);
      xBucketWidth.f4 = PG_GETARG_FLOAT4(5);
      yBucketWidth.f4 = PG_GETARG_FLOAT4(6);
      if (xBucketWidth.f4 <= 0) elog(ERROR, "hist_2d x_bucket_width must be greater than zero");
      if (yBucketWidth.f4 <= 0) elog(ERROR, "hist_2d y_bucket_width must be greater than zero");
      break;
    case FLOAT8OID:
      xVal.f8 = PG_GETARG_FLOAT8(1);
      yVal.f8 = PG_GETARG_FLOAT8(2);
      xStart.f8 = PG_GETARG_FLOAT8(3);
      yStart.f8 = PG_GETARG_FLOAT8(4);
      xBucketWidth.f8 = PG_GETARG_FLOAT8(5);
      yBucketWidth.f8 = PG_GETARG_FLOAT8(6);
      if (xBucketWidth.f8 <= 0) elog(ERROR, "hist_2d x_bucket_width must be greater than zero");
      if (yBucketWidth.f8 <= 0) elog(ERROR, "hist_2d y_bucket_width must be greater than zero");
      break;
    default:
      ereport(ERROR, (errmsg("hist_2d operands must be numeric types")));
  }

  if (PG_ARGISNULL(7)) {
    elog(ERROR, "hist_2d x_bucket_count can't be null");
  } else {
    xLength = PG_GETARG_INT32(7);
    if (xLength <= 0) elog(ERROR, "hist_2d x_bucket_count must be greater than zero");
  }

  if (PG_ARGISNULL(8)) {
    elog(ERROR, "hist_2d y_bucket_count can't be null");
  } else {
    yLength = PG_GETARG_INT32(8);
    if (yLength <= 0) elog(ERROR, "hist_2d y_bucket_count must be greater than zero");
  }

  if (PG_ARGISNULL(0)) {
    arrayLength = xLength * yLength;
    state = initVecArrayResultWithNulls(elemTypeId, INT4OID, aggContext, arrayLength);
    memset(state->state.dnulls, 0, state->state.alen * sizeof(bool));
    state->vecvalues[0].i32 = xLength;
    state->vecvalues[1].i32 = yLength;
  } else {
    state = (VecArrayBuildState *)PG_GETARG_POINTER(0);
  }

  if (PG_ARGISNULL(1) || PG_ARGISNULL(2)) {
    // just return the current state unchanged
    PG_RETURN_POINTER(state);
  }

  switch (elemTypeId) {
    case INT2OID:
      xPos = (xVal.i16 - xStart.i16) / xBucketWidth.i16;
      yPos = (yVal.i16 - yStart.i16) / yBucketWidth.i16;
      break;
    case INT4OID:
      xPos = (xVal.i32 - xStart.i32) / xBucketWidth.i32;
      yPos = (yVal.i32 - yStart.i32) / yBucketWidth.i32;
      break;
    case INT8OID:
      xPos = (xVal.i64 - xStart.i64) / xBucketWidth.i64;
      yPos = (yVal.i64 - yStart.i64) / yBucketWidth.i64;
      break;
    case FLOAT4OID:
      xPos = (xVal.f4 - xStart.f4) / xBucketWidth.f4;
      yPos = (yVal.f4 - yStart.f4) / yBucketWidth.f4;
      break;
    case FLOAT8OID:
      xPos = (xVal.f8 - xStart.f8) / xBucketWidth.f8;
      yPos = (yVal.f8 - yStart.f8) / yBucketWidth.f8;
      break;
  }

  if (xPos >= 0 && xPos < xLength && yPos >= 0 && yPos < yLength) {
    state->veccounts[yPos * xLength + xPos] += 1;
  }

  PG_RETURN_POINTER(state);
}

Datum hist_2d_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(hist_2d_finalfn);

Datum
hist_2d_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  VecArrayBuildState *state;
  int dims[2];
  int lbs[2];     // Lower Bounds of each dimension
  int i;

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (VecArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL) PG_RETURN_NULL();

  for (i = 0; i < state->state.nelems; i++) {
    state->state.dvalues[i] = UInt32GetDatum(state->veccounts[i]);
  }

  dims[0] = state->vecvalues[0].i32;
  dims[1] = state->vecvalues[1].i32;
  lbs[0] = 1;
  lbs[1] = 1;

  result = makeMdArrayResult(&state->state, 2, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
