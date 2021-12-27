
Datum vec_to_last_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_last_transfn);

/**
 * Returns an of n elements, which each element is the last non-null value found in that position
 * from all input arrays.
 */
Datum
vec_to_last_transfn(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int currentLength;
  MemoryContext aggContext;
  ArrayBuildState *state = NULL;
  ArrayType *currentArray;
  int arrayLength;
  Datum *currentVals;
  bool *currentNulls;
  int i;
  MemoryContext old = NULL;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_last_transfn called in non-aggregate context");
  }

  if (!PG_ARGISNULL(0)) {
    state = (ArrayBuildState *)PG_GETARG_POINTER(0);
  }

  if (PG_ARGISNULL(1)) {
    // just return the current state unchanged (possibly still NULL)
    PG_RETURN_POINTER(state);
  }
  currentArray = PG_GETARG_ARRAYTYPE_P(1);
  if (ARR_NDIM(currentArray) == 0) {
    PG_RETURN_POINTER(state);
  }

  if (state == NULL) {
    elemTypeId = ARR_ELEMTYPE(currentArray);
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("vec_to_last: one-dimensional arrays are required, but got %d", ARR_NDIM(currentArray))));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    state = initArrayResultWithNulls(elemTypeId, aggContext, arrayLength);
  } else {
    elemTypeId = state->element_type;
    arrayLength = state->nelems;
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("vec_to_last: all arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  if (!elemTypeByValue) old = MemoryContextSwitchTo(aggContext);
  for (i = 0; i < arrayLength; i++) {
    if (!currentNulls[i]) {
      if (state->dnulls[i]) {
        state->dnulls[i] = false;
      } else if (!elemTypeByValue) {
        // free previously seen datum
        pfree(DatumGetPointer(state->dvalues[i]));
      }
      state->dvalues[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
    }
  }
  if (!elemTypeByValue) MemoryContextSwitchTo(old);
  PG_RETURN_POINTER(state);
}

Datum vec_to_last_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_last_finalfn);

Datum
vec_to_last_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  ArrayBuildState *state;
  int dims[1];
  int lbs[1];

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (ArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL)
    PG_RETURN_NULL();

  dims[0] = state->nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
