
Datum vec_agg_min_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_min_finalfn);

/**
 * Extract an array of mins from a VecAggAccumState.
 */
Datum
vec_agg_min_finalfn(PG_FUNCTION_ARGS)
{
  ArrayType *result;
  VecAggAccumState *state;
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
  get_typlenbyvalalign(state->elementType, &typlen, &typbyval, &typalign);

  for (i = 0; i < state->nelems; i++) {
    if (state->vec_counts[i]) {
      dvalues[i] = datumCopy(state->vec_mins[i], typbyval, typlen);
      dnulls[i] = false;
    } else {
      dnulls[i] = true;
    }
  }

  dims[0] = state->nelems;
  lbs[0] = 1;

  result = construct_md_array(dvalues, dnulls, 1, dims, lbs, state->elementType, typlen, typbyval, typalign);  
  PG_RETURN_ARRAYTYPE_P(result);
}
