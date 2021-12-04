
Datum vec_to_weighted_mean_numeric_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_weighted_mean_numeric_transfn);

/**
 * Returns an of n elements,
 * which each element is the weighted mean of the values found in that position
 * from all input arrays. The second parameter is an array of weights.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_weighted_mean_numeric_transfn(PG_FUNCTION_ARGS)
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
  MemoryContext old;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_weighted_mean_numeric_transfn called in non-aggregate context");
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
    elemWeightTypeId = ARR_ELEMTYPE(currentWeightArray);
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
    state = initVecArrayResultWithNulls(elemTypeId, NUMERICOID, aggContext, arrayLength);
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

  old = MemoryContextSwitchTo(aggContext);
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i] || currentWeightNulls[i]) {
      // do nothing: nulls can't change the result.
    } else if (state->state.dnulls[i]) {
      state->state.dnulls[i] = false;
      state->vecvalues[i].num = DatumGetNumeric(DirectFunctionCall2(
              numeric_mul,
              currentWeightVals[i],
              currentVals[i]));
      state->vectmpvalues[i].num = DatumGetNumericCopy(currentWeightVals[i]);
    } else {
      // Instead of performing sub/div/add numeric calculations each row,
    // just add and complete later in final function.
    // NUMERIC precision should be plenty.
#if PG_VERSION_NUM < 120000
      state->vecvalues[i].num = DatumGetNumeric(DirectFunctionCall2(
          numeric_add,
          NumericGetDatum(state->vecvalues[i].num),
          DirectFunctionCall2(
            numeric_mul,
            currentWeightVals[i],
            currentVals[i])));
    state->vectmpvalues[i].num = DatumGetNumeric(DirectFunctionCall2(
        numeric_add,
        NumericGetDatum(state->vectmpvalues[i].num),
        currentWeightVals[i]));
#else
      state->vecvalues[i].num = numeric_add_opt_error(
        state->vecvalues[i].num,
        numeric_mul_opt_error(
          DatumGetNumeric(currentWeightVals[i]),
          DatumGetNumeric(currentVals[i]),
          NULL),
        NULL);
    state->vectmpvalues[i].num = numeric_add_opt_error(
        state->vectmpvalues[i].num,
        DatumGetNumeric(currentWeightVals[i]),
        NULL);
#endif
    }
  }
  MemoryContextSwitchTo(old);
  PG_RETURN_POINTER(state);
}

Datum vec_to_weighted_mean_numeric_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_weighted_mean_numeric_finalfn);

Datum
vec_to_weighted_mean_numeric_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  VecArrayBuildState *state;
  int dims[1];
  int lbs[1];
  int i;
  Datum div;

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (VecArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL)
    PG_RETURN_NULL();

  // Convert from our pgnums to Datums:
  for (i = 0; i < state->state.nelems; i++) {
    if (state->state.dnulls[i]) continue;
#if PG_VERSION_NUM < 120000
    div = DirectFunctionCall2(numeric_div, NumericGetDatum(state->vecvalues[i].num), NumericGetDatum(state->vectmpvalues[i].num));
#else
    div = NumericGetDatum(numeric_div_opt_error(state->vecvalues[i].num, state->vectmpvalues[i].num, NULL));
#endif

    state->state.dvalues[i] = div;
  }

  dims[0] = state->state.nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(&state->state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
