
Datum pad_vec(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(pad_vec);

/**
 * Pads a vector with NULLs out to n elements if necessary.
 * If the vector has more than n elements we raise an error.
 *
 * by Paul A. Jungwirth
 */
Datum
pad_vec(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  ArrayType *currentArray;
  int currentLength;
  Datum *currentVals;
  bool *currentNulls;
  int i;
  int arraySize;
  ArrayBuildState *state;
  Datum result;

  if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) PG_RETURN_NULL();

  currentArray = PG_GETARG_ARRAYTYPE_P(0);
  arraySize = PG_GETARG_INT32(1);

  elemTypeId = ARR_ELEMTYPE(currentArray);
  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);

  if (currentLength == arraySize) {
    PG_RETURN_ARRAYTYPE_P(currentArray);

  } else if (currentLength < arraySize) {
    state = initArrayResultWithNulls(elemTypeId, CurrentMemoryContext, arraySize);
    for (i = 0; i < currentLength; i++) {
      if (!currentNulls[i]) {
        state->dnulls[i] = false;
        state->dvalues[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
      }
    }
    result = makeArrayResult(state, CurrentMemoryContext);
    PG_RETURN_DATUM(result);

  } else {
    ereport(ERROR, (errmsg("pad_vec found an array with %d elements but we're trying to pad out to only %d", currentLength, arraySize)));
  }
}
