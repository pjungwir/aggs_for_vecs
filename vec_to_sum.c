
Datum vec_to_sum_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_sum_transfn);

/**
 * Returns an array of n elements,
 * which each element is the sum of non-NULLs found in that position
 * from all input arrays.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_sum_transfn(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int currentLength;
  MemoryContext aggContext;
  VecArrayBuildState *state = NULL;
  ArrayType *currentArray;
  int arrayLength;
  Datum *currentVals;
  bool *currentNulls;
  int i;
  MemoryContext old;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_sum_transfn called in non-aggregate context");
  }

  // PG_ARGISNULL tests for SQL NULL,
  // but after the first pass we can have a
  // value that is non-SQL-NULL but still is C NULL.
  if (!PG_ARGISNULL(0)) {
    state = (VecArrayBuildState *)PG_GETARG_POINTER(0);
  }

  if (PG_ARGISNULL(1)) {
    // just return the current state unchanged (possibly still NULL)
    PG_RETURN_POINTER(state);
  }
  currentArray = PG_GETARG_ARRAYTYPE_P(1);

  if (state == NULL) {
    // Since we have our first not-null argument
    // we can initialize the state to match its length.
    elemTypeId = ARR_ELEMTYPE(currentArray);
    if (elemTypeId != INT2OID &&
        elemTypeId != INT4OID &&
        elemTypeId != INT8OID &&
        elemTypeId != FLOAT4OID &&
        elemTypeId != FLOAT8OID &&
        elemTypeId != NUMERICOID) {
      ereport(ERROR, (errmsg("vec_to_sum input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC")));
    }
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    // Start with all zeros:
    state = initVecArrayResultWithNulls(elemTypeId, elemTypeId, aggContext, arrayLength);
    if (elemTypeId == NUMERICOID) old = MemoryContextSwitchTo(aggContext);
    for (i = 0; i < arrayLength; i++) {
      switch (elemTypeId) {
        case INT2OID:
          state->vecvalues[i].i16 = 0;
          break;
        case INT4OID:
          state->vecvalues[i].i32 = 0;
          break;
        case INT8OID:
          state->vecvalues[i].i64 = 0;
          break;
        case FLOAT4OID:
          state->vecvalues[i].f4 = 0;
          break;
        case FLOAT8OID:
          state->vecvalues[i].f8 = 0;
          break;
        case NUMERICOID:
          state->vecvalues[i].num = DatumGetNumeric(DirectFunctionCall1(int8_numeric, Int64GetDatum(0)));
          break;
        default:
          elog(ERROR, "Unknown elemTypeId!");
      }
      state->state.dnulls[i] = true;
    }
    if (elemTypeId == NUMERICOID) MemoryContextSwitchTo(old);
  } else {
    elemTypeId = state->inputElementType;
    arrayLength = state->state.nelems;
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  // Make sure we allocate Numerics in a context that will persist between calls!:
  if (elemTypeId == NUMERICOID) old = MemoryContextSwitchTo(aggContext);
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else {
      state->state.dnulls[i] = false;
      switch (elemTypeId) {
        case INT2OID:
          state->vecvalues[i].i16 += DatumGetInt16(currentVals[i]);
          break;
        case INT4OID:
          state->vecvalues[i].i32 += DatumGetInt32(currentVals[i]);
          break;
        case INT8OID:
          state->vecvalues[i].i64 += DatumGetInt64(currentVals[i]);
          break;
        case FLOAT4OID:
          state->vecvalues[i].f4 += DatumGetFloat4(currentVals[i]);
          break;
        case FLOAT8OID:
          state->vecvalues[i].f8 += DatumGetFloat8(currentVals[i]);
          break;
        case NUMERICOID:
 #if PG_VERSION_NUM < 120000
          state->vecvalues[i].num = DatumGetNumeric(DirectFunctionCall2(numeric_add,
                      NumericGetDatum(state->vecvalues[i].num),
                      currentVals[i]));
  #else
          state->vecvalues[i].num = numeric_add_opt_error(state->vecvalues[i].num, DatumGetNumeric(currentVals[i]), NULL);
  #endif
          break;
        default:
          elog(ERROR, "Unknown elemTypeId!");
      }
    }
  }
  if (elemTypeId == NUMERICOID) MemoryContextSwitchTo(old);
  PG_RETURN_POINTER(state);
}

Datum vec_to_sum_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_sum_finalfn);

Datum
vec_to_sum_finalfn(PG_FUNCTION_ARGS)
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
    switch (state->inputElementType) {
      case INT2OID:
        state->state.dvalues[i] = Int16GetDatum(state->vecvalues[i].i16);
        break;
      case INT4OID:
        state->state.dvalues[i] = Int32GetDatum(state->vecvalues[i].i32);
        break;
      case INT8OID:
        state->state.dvalues[i] = Int64GetDatum(state->vecvalues[i].i64);
        break;
      case FLOAT4OID:
        state->state.dvalues[i] = Float4GetDatum(state->vecvalues[i].f4);
        break;
      case FLOAT8OID:
        state->state.dvalues[i] = Float8GetDatum(state->vecvalues[i].f8);
        break;
      case NUMERICOID:
        state->state.dvalues[i] = NumericGetDatum(state->vecvalues[i].num);
        break;
    }
  }

  dims[0] = state->state.nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(&state->state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
