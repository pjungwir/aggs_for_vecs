
Datum vec_to_mean_numeric_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_mean_numeric_transfn);

/**
 * Returns an array of n elements,
 * which each element is the mean value found in that position
 * from all input arrays.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_mean_numeric_transfn(PG_FUNCTION_ARGS)
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
    elog(ERROR, "vec_to_mean_numeric_transfn called in non-aggregate context");
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
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    // Just start with all NULLs and let the comparisons below replace them:
    state = initVecArrayResultWithNulls(elemTypeId, NUMERICOID, aggContext, arrayLength);
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

  old = MemoryContextSwitchTo(aggContext);
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else if (state->state.dnulls[i]) {
      state->state.dnulls[i] = false;
      state->veccounts[i] = 1;
      state->vecvalues[i].num = DatumGetNumericCopy(currentVals[i]);
    } else {
      state->veccounts[i] += 1;
      // instead of performing sub/div/add numeric calculations each row, just add and complete later in final function
      state->vecvalues[i].num = DatumGetNumeric(DirectFunctionCall2(numeric_add,
                  NumericGetDatum(state->vecvalues[i].num),
                  currentVals[i]));
    }
  }
  MemoryContextSwitchTo(old);
  PG_RETURN_POINTER(state);
}

Datum vec_to_mean_numeric_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_mean_numeric_finalfn);

Datum
vec_to_mean_numeric_finalfn(PG_FUNCTION_ARGS)
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
    Datum count = DirectFunctionCall1(int8_numeric, UInt32GetDatum(state->veccounts[i]));
    Datum div = DirectFunctionCall2(numeric_div, NumericGetDatum(state->vecvalues[i].num), count);

    // trim the output scale to drop trailing zeros; in PG13 the trim_scale function is available,
    // otherwise manually find the appropriate scale to trim to
#if PG_VERSION_NUM >= 130000
    div = DirectFunctionCall1(trim_scale, div);
#else
    div = trimScaleNumeric(div);
#endif
    state->state.dvalues[i] = div;
  }

  dims[0] = state->state.nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(&state->state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
