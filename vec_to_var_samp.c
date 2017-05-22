
Datum vec_to_var_samp_transfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_var_samp_transfn);

/**
 * Returns an of n elements,
 * which each element is the sample variance value found in that position
 * from all input arrays.
 *
 * We use the sample approach as the built in VAR_SAMP aggregate.
 * See float8_var_samp in backend/utils/adt/float.c for details.
 * Our transition function records N, sum(X), and sum(X^2) for each array element,
 * and then the final function uses those to compute the sample variance,
 * based on:
 *
 *     s^2 = \frac{ \sum{}X^2 - \frac{(\sum{}X)^2}{N} }{N - 1}
 *
 * aka
 *           Σ X^2 - ((Σ X)^2)/N
 *     s^2 = -------------------
 *                  N - 1
 *
 * Using this formula rather than the more common one
 * lets us keep just 3 numbers (for each array position) as we go,
 * whereas to find X - mean(X) for each X
 * we'd have to keep all the values around until we knew the mean.
 *
 * This can over/underflow, but we report an error if that happens,
 * and it's no worse than the built-in aggregate.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_to_var_samp_transfn(PG_FUNCTION_ARGS)
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
  float tmp_f;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_to_var_samp_transfn called in non-aggregate context");
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
        elemTypeId != FLOAT8OID) {
      ereport(ERROR, (errmsg("vec_to_var_samp input must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION")));
    }
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    // Just start with all NULLs and let the comparisons below replace them:
    state = initVecArrayResultWithNulls(elemTypeId, FLOAT8OID, aggContext, arrayLength);
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

  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else if (state->veccounts[i] == 0) {
      state->veccounts[i] = 1;
      switch (elemTypeId) {
        case INT2OID:   state->vecvalues[i].f8 = DatumGetInt16(currentVals[i]);  break;
        case INT4OID:   state->vecvalues[i].f8 = DatumGetInt32(currentVals[i]);  break;
        case INT8OID:   state->vecvalues[i].f8 = DatumGetInt64(currentVals[i]);  break;
        case FLOAT4OID: state->vecvalues[i].f8 = DatumGetFloat4(currentVals[i]); break;
        case FLOAT8OID: state->vecvalues[i].f8 = DatumGetFloat8(currentVals[i]); break;
        default: elog(ERROR, "Unknown elemTypeId!");
      }
      state->vectmpvalues[i].f8 = state->vecvalues[i].f8 * state->vecvalues[i].f8;
    } else {
      state->veccounts[i] += 1;
      switch (elemTypeId) {
        case INT2OID:   tmp_f = DatumGetInt16(currentVals[i]);  break;
        case INT4OID:   tmp_f = DatumGetInt32(currentVals[i]);  break;
        case INT8OID:   tmp_f = DatumGetInt64(currentVals[i]);  break;
        case FLOAT4OID: tmp_f = DatumGetFloat4(currentVals[i]); break;
        case FLOAT8OID: tmp_f = DatumGetFloat8(currentVals[i]); break;
        default: elog(ERROR, "Unknown elemTypeId!");
      }
      state->vecvalues[i].f8    += tmp_f;
      state->vectmpvalues[i].f8 += tmp_f * tmp_f;
    }
  }
  PG_RETURN_POINTER(state);
}

Datum vec_to_var_samp_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_to_var_samp_finalfn);

Datum
vec_to_var_samp_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  VecArrayBuildState *state;
  int dims[1];
  int lbs[1];
  int i;
  float8 numerator;

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (VecArrayBuildState *)PG_GETARG_POINTER(0);

  if (state == NULL) PG_RETURN_NULL();

  // Convert from our pgnums to Datums:
  for (i = 0; i <= state->state.nelems; i++) {
    // Sample variance is undefined if N is 0 *or* 1:
    if (state->veccounts[i] > 1) {
      state->state.dnulls[i] = false;

      numerator = state->veccounts[i] * state->vectmpvalues[i].f8 - state->vecvalues[i].f8 * state->vecvalues[i].f8;
      CHECKFLOATVAL(numerator, isinf(state->vectmpvalues[i].f8) || isinf(state->vecvalues[i].f8), true);

      /* Watch out for roundoff error producing a negative numerator */
      if (numerator <= 0.0) {
        state->state.dvalues[i] = Float8GetDatum(0.0);
      } else {
        state->state.dvalues[i] = Float8GetDatum(numerator / (state->veccounts[i] * (state->veccounts[i] - 1)));
      }
    }
  }

  dims[0] = state->state.nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(&state->state, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
