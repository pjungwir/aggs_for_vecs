
Datum vec_to_max_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_max_transfn);

/**
 * Returns an of n elements,
 * which each element is the max value found in that position
 * from all input arrays.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_max_transfn(PG_FUNCTION_ARGS)
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
  MemoryContext old;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_max_transfn called in non-aggregate context");
  }

  // PG_ARGISNULL tests for SQL NULL,
  // but after the first pass we can have a
  // value that is non-SQL-NULL but still is C NULL.
  if (!PG_ARGISNULL(0)) {
    state = (ArrayBuildState *)PG_GETARG_POINTER(0);
  }

  if (PG_ARGISNULL(1)) {
    // just return the current state unchanged (possibly still NULL)
    PG_RETURN_POINTER(state);
  }
  currentArray = PG_GETARG_ARRAYTYPE_P(1);

  if (state == NULL) {
    // Since we have our first not-null argument
    // we can initialize the state to match its type & length.
    elemTypeId = ARR_ELEMTYPE(currentArray);
    if (elemTypeId != INT2OID &&
        elemTypeId != INT4OID &&
        elemTypeId != INT8OID &&
        elemTypeId != FLOAT4OID &&
        elemTypeId != FLOAT8OID &&
        elemTypeId != NUMERICOID) {
      ereport(ERROR, (errmsg("vec_to_max input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC")));
    }
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    // Just start with all NULLs and let the comparisons below replace them:
    state = initArrayResultWithNulls(elemTypeId, aggContext, arrayLength);
  } else {
    elemTypeId = state->element_type;
    arrayLength = state->nelems;
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  if (elemTypeId == NUMERICOID) old = MemoryContextSwitchTo(aggContext);
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else if (state->dnulls[i]) {
      state->dnulls[i] = false;
      if (elemTypeByValue) {
        state->dvalues[i] = currentVals[i];
      } else {
        // only by-reference type supported is NUMERIC
        Numeric n = DatumGetNumericCopy(currentVals[i]);
        state->dvalues[i] = NumericGetDatum(n);
      }
    } else {
      // Moving this switch outside the for loop makes sense
      // but doesn't seem to change performance at all,
      // and it's more DRY leaving it here.
      switch (elemTypeId) {
        case INT2OID:
          if (DatumGetInt16(currentVals[i]) > DatumGetInt16(state->dvalues[i])) state->dvalues[i] = currentVals[i];
          break;
        case INT4OID:
          if (DatumGetInt32(currentVals[i]) > DatumGetInt32(state->dvalues[i])) state->dvalues[i] = currentVals[i];
          break;
        case INT8OID:
          if (DatumGetInt64(currentVals[i]) > DatumGetInt64(state->dvalues[i])) state->dvalues[i] = currentVals[i];
          break;
        case FLOAT4OID:
          if (DatumGetFloat4(currentVals[i]) > DatumGetFloat4(state->dvalues[i])) state->dvalues[i] = currentVals[i];
          break;
        case FLOAT8OID:
          if (DatumGetFloat8(currentVals[i]) > DatumGetFloat8(state->dvalues[i])) state->dvalues[i] = currentVals[i];
          break;
        case NUMERICOID:
          if (DatumGetBool(DirectFunctionCall2(numeric_gt, currentVals[i], state->dvalues[i]))) state->dvalues[i] = currentVals[i];
          break;
        default:
          elog(ERROR, "Unknown elemTypeId!");
      }
    }
  }
  if (elemTypeId == NUMERICOID) MemoryContextSwitchTo(old);
  PG_RETURN_POINTER(state);
}

Datum vec_to_max_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_max_finalfn);

Datum
vec_to_max_finalfn(PG_FUNCTION_ARGS)
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
