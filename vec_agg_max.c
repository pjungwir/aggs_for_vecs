
Datum vec_agg_max_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_max_finalfn);

/**
 * Extract an array of maxes from a VecAggAccumState.
 */
Datum
vec_agg_max_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  ArrayBuildState *result_build;
  VecAggAccumState *state;
  int dims[1];
  int lbs[1];
  int i;

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);
  if (state == NULL || state->nelems < 1) {
    PG_RETURN_NULL();
  }

  result_build = initArrayResultWithNulls(state->elementType, CurrentMemoryContext, state->nelems);

  for (i = 0; i < state->nelems; i++) {
    if (state->vec_counts[i]) {
      result_build->dvalues[i] = state->vec_maxes[i]; // TODO: need copy?
      result_build->dnulls[i] = false;
    }
  }

  dims[0] = result_build->nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(result_build, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
