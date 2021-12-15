
Datum vec_agg_sum_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_sum_finalfn);

/**
 * Extract an array of means from a VecAggAccumState.
 */
Datum
vec_agg_sum_finalfn(PG_FUNCTION_ARGS)
{
  ArrayType *result;
  VecAggAccumState *state;
  LOCAL_FCINFO(delegate_fcinfo, 1);
  PGFunction delegate_func;
  Datum tmpDatum;
  int16 typlen;
  bool typbyval;
  char typalign;
  Datum *dvalues;
  bool *dnulls;
  int dims[1];
  int lbs[1];
  int i;

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);
  if (state == NULL || state->nelems < 1) {
    PG_RETURN_NULL();
  }

  dvalues = palloc(state->nelems * sizeof(Datum));
  dnulls = palloc(state->nelems * sizeof(bool));

  InitFunctionCallInfoData(*delegate_fcinfo, NULL, 1, fcinfo->fncollation, fcinfo->context, fcinfo->resultinfo);
  FC_NULL(delegate_fcinfo, 0) = false;
  
  for (i = 0; i < state->nelems; i++) {
    if (state->vec_counts[i]) {
      switch(state->elementType) {
        // TODO: support other number types
        case NUMERICOID:
            delegate_func = numeric_sum;
            break;
        default:
            elog(ERROR, "Unknown array element type");
      }
      FC_ARG(delegate_fcinfo, 0) = state->vec_states[i];
      tmpDatum = (*delegate_func) (delegate_fcinfo);
      if (delegate_fcinfo->isnull) elog(ERROR, "Delegate function %p returned NULL", (void *) delegate_func);
      dvalues[i] = tmpDatum;
      dnulls[i] = false;
    } else {
      dnulls[i] = true;
    }
  }

  dims[0] = state->nelems;
  lbs[0] = 1;

  get_typlenbyvalalign(state->elementType, &typlen, &typbyval, &typalign);
  result = construct_md_array(dvalues, dnulls, 1, dims, lbs, state->elementType, typlen, typbyval, typalign);  
  PG_RETURN_ARRAYTYPE_P(result);
}
