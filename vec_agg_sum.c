
Datum vec_agg_sum_finalfn(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_agg_sum_finalfn);

/**
 * Extract an array of sums from a VecAggAccumState.
 */
Datum
vec_agg_sum_finalfn(PG_FUNCTION_ARGS)
{
  ArrayType *result;
  VecAggAccumState *state;
  LOCAL_FCINFO(delegate_fcinfo, 1);
  PGFunction delegate_func;
  ArrayType  *transarray;
  Datum tmpDatum;
  int16 typlen;
  bool typbyval;
  char typalign;
  Datum *dvalues;
  bool *dnulls;
  Oid resultType;
  int dims[1];
  int lbs[1];
  int i;

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);
  if (state == NULL || state->nelems < 1) {
    PG_RETURN_NULL();
  }

  dvalues = palloc(state->nelems * sizeof(Datum));
  dnulls = palloc(state->nelems * sizeof(bool));

  if (state->elementType == INT8OID || state->elementType == NUMERICOID) {
    InitFunctionCallInfoData(*delegate_fcinfo, NULL, 1, fcinfo->fncollation, fcinfo->context, fcinfo->resultinfo);
    FC_NULL(delegate_fcinfo, 0) = false;
    delegate_func = (state->elementType == INT8OID ? numeric_poly_sum : numeric_sum);
    resultType = NUMERICOID;
  } else if (state->elementType == FLOAT4OID || state->elementType == FLOAT8OID) {
    delegate_func = NULL;
    resultType = FLOAT8OID;
  } else {
    delegate_func = NULL;
    resultType = INT8OID;
  }

  for (i = 0; i < state->nelems; i++) {
    if (state->vec_counts[i]) {
      if (state->elementType == INT8OID || state->elementType == NUMERICOID) {
        FC_ARG(delegate_fcinfo, 0) = state->vec_states[i];
        tmpDatum = (*delegate_func) (delegate_fcinfo);
        if (delegate_fcinfo->isnull) elog(ERROR, "Delegate function %p returned NULL", (void *) delegate_func);
        dvalues[i] = tmpDatum;
      } else {
        switch(state->elementType) {
          case INT2OID:
          case INT4OID:
            // the sum is the 2nd element of the int8[] state array
            transarray = DatumGetArrayTypeP(state->vec_states[i]);
            dvalues[i] = Int64GetDatumFast(((int64 *)ARR_DATA_PTR(transarray))[1]);
            break;

          case FLOAT4OID:
          case FLOAT8OID:
            // the sum is the 2nd element of the float8[] state array
            transarray = DatumGetArrayTypeP(state->vec_states[i]);
            dvalues[i] = Float8GetDatumFast(((float8 *)ARR_DATA_PTR(transarray))[1]);
            break;

          default:
            elog(ERROR, "Unknown array element type");
        }
      }
      dnulls[i] = false;
    } else {
      dnulls[i] = true;
    }
  }

  dims[0] = state->nelems;
  lbs[0] = 1;

  get_typlenbyvalalign(resultType, &typlen, &typbyval, &typalign);
  result = construct_md_array(dvalues, dnulls, 1, dims, lbs, resultType, typlen, typbyval, typalign);  
  PG_RETURN_ARRAYTYPE_P(result);
}
