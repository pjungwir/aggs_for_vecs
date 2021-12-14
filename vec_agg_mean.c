
Datum vec_agg_mean_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_mean_finalfn);

/**
 * Extract an array of means from a VecAggAccumState.
 */
Datum
vec_agg_mean_finalfn(PG_FUNCTION_ARGS)
{
  Datum result;
  ArrayBuildState *result_build;
  VecAggAccumState *state;
  LOCAL_FCINFO(delegate_fcinfo, 1);
  PGFunction delegate_func;
  Datum tmpDatum;
  int dims[1];
  int lbs[1];
  int i;

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);
  if (state == NULL || state->nelems < 1) {
    PG_RETURN_NULL();
  }

  result_build = initArrayResultWithNulls(state->elementType, CurrentMemoryContext, state->nelems);

  InitFunctionCallInfoData(*delegate_fcinfo, NULL, 1, fcinfo->fncollation, fcinfo->context, fcinfo->resultinfo);
  FC_NULL(delegate_fcinfo, 0) = false;

  for (i = 0; i < state->nelems; i++) {
    if (state->vec_counts[i]) {
      switch(state->elementType) {
        // TODO: support other number types
        case NUMERICOID:
            delegate_func = numeric_avg;
            break;
        default:
            elog(ERROR, "Unknown array element type");
      }
      FC_ARG(delegate_fcinfo, 0) = state->vec_states[i];
      tmpDatum = (*delegate_func) (delegate_fcinfo);
      if (delegate_fcinfo->isnull) elog(ERROR, "Delegate function %p returned NULL", (void *) delegate_func);
      result_build->dvalues[i] = tmpDatum;
      result_build->dnulls[i] = false;
    }
  }

  dims[0] = result_build->nelems;
  lbs[0] = 1;

  result = makeMdArrayResult(result_build, 1, dims, lbs, CurrentMemoryContext, false);
  PG_RETURN_DATUM(result);
}
