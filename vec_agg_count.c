
Datum vec_agg_count_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_count_finalfn);

/**
 * Extract an array of counts from a VecAggAccumState.
 */
Datum
vec_agg_count_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  ArrayBuildState *result_build;
  VecAggAccumState *state;
  int dims[1];
  int lbs[1];
  int i;

  Assert(AggCheckCallContext(fcinfo, NULL));

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);
  if (state == NULL || state->nelems < 1) {
    PG_RETURN_NULL();
  }

  result_build = initArrayResultWithNulls(INT8OID, CurrentMemoryContext, state->nelems);

  for (i = 0; i < state->nelems; i++) {
    result_build->dvalues[i] = Int64GetDatum(state->vec_counts[i]);
    result_build->dnulls[i] = false;
  }

  dims[0] = result_build->nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(result_build, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
