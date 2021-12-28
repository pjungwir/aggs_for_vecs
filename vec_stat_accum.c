
Datum vec_stat_accum(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_stat_accum);

/**
 * Aggregate transition function for accumulating basic statistics via
 * delegate aggregate transition function and comparison functions.
 */
Datum
vec_stat_accum(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int currentLength;
  MemoryContext aggContext;
  VecAggAccumState *state;
  ArrayType *currentArray;
  int arrayLength;
  Datum *currentVals;
  bool *currentNulls;
  int i;
  MemoryContext oldContext;
  Datum *istate_elements;
  int16 istate_typlen;
  bool istate_typbyval;
  char istate_typalign;
  Datum compareResult;
  TypeCacheEntry *typentry;
  PGFunction accum_func;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_stat_agg called in non-aggregate context");
  }

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);

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
      ereport(ERROR, (errmsg("vec_stat_accum: one-dimensional arrays are required, but got %d", ARR_NDIM(currentArray))));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    state = initVecAggAccumState(elemTypeId, aggContext, arrayLength);
    // Set up the delegate aggregate transition/compare function calls
    state->transfn_fcinfo = HEAP_FCINFO(aggContext,  2);
    InitFunctionCallInfoData(*state->transfn_fcinfo, NULL, 2, fcinfo->fncollation, fcinfo->context, fcinfo->resultinfo);
    FC_NULL(state->transfn_fcinfo, 1) = false;

    state->cmp_fcinfo = HEAP_FCINFO(aggContext,  2);
    typentry = lookup_type_cache(elemTypeId, TYPECACHE_CMP_PROC_FINFO);
    InitFunctionCallInfoData(*state->cmp_fcinfo, &typentry->cmp_proc_finfo, 2, InvalidOid, NULL, NULL);
    FC_NULL(state->cmp_fcinfo, 0) = false;
    FC_NULL(state->cmp_fcinfo, 1) = false;
  } else {
    elemTypeId = state->elementType;
    arrayLength = state->nelems;
  }
  switch(elemTypeId) {
    case INT2OID:
      accum_func = int2_avg_accum;
      break;

    case INT4OID:
      accum_func = int4_avg_accum;
      break;

    case INT8OID:
      accum_func = int8_avg_accum;
      break;

    case FLOAT4OID:
      accum_func = float4_accum;
      break;

    case FLOAT8OID:
      accum_func = float8_accum;
      break;

    case NUMERICOID:
      accum_func = numeric_avg_accum;
      break;

    default:
      elog(ERROR, "Unknown array element type");
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("vec_stat_accum: all arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  // for each input element, delegate to 
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else {
      if (!state->vec_counts[i]) {
        // first call to delegate aggregate transition, so must init transfn_fcinfo if not already
        switch(elemTypeId) {
          case INT2OID:
          case INT4OID:
            // expects an int8[2] array initial state
            FC_NULL(state->transfn_fcinfo, 0) = false;
            get_typlenbyvalalign(INT8OID, &istate_typlen, &istate_typbyval, &istate_typalign);
            oldContext = MemoryContextSwitchTo(aggContext); {
              istate_elements = palloc(2 * sizeof(Datum));
              istate_elements[0] = Int64GetDatum(0);
              istate_elements[1] = istate_elements[0];
              state->vec_states[i] = PointerGetDatum(construct_array(istate_elements, 2, INT8OID, istate_typlen, istate_typbyval, istate_typalign));
            } MemoryContextSwitchTo(oldContext);
            break;

          case FLOAT4OID:
          case FLOAT8OID:
            // expects a float8[3] array initial state
            FC_NULL(state->transfn_fcinfo, 0) = false;
            get_typlenbyvalalign(FLOAT8OID, &istate_typlen, &istate_typbyval, &istate_typalign);
            oldContext = MemoryContextSwitchTo(aggContext); {
              istate_elements = palloc(3 * sizeof(Datum));
              istate_elements[0] = Float8GetDatum(0);
              istate_elements[1] = istate_elements[0];
              istate_elements[2] = istate_elements[0];
              state->vec_states[i] = PointerGetDatum(construct_array(istate_elements, 3, FLOAT8OID, istate_typlen, istate_typbyval, istate_typalign));
            } MemoryContextSwitchTo(oldContext);
            break;

          case INT8OID:
          case NUMERICOID:
            // expects a NULL initial state
            FC_NULL(state->transfn_fcinfo, 0) = true;
            break;
          
          default:
            elog(ERROR, "Unknown array element type");
        }

        // first non-null element set up as initial min/max values
        // note we create 2 copies because we pfree mins/maxes individually later as needed
        oldContext = MemoryContextSwitchTo(aggContext); {
          state->vec_mins[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
          state->vec_maxes[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
        } MemoryContextSwitchTo(oldContext);
      } else {
        FC_NULL(state->transfn_fcinfo, 0) = false;

        // execute delegate comparison function for min
        FC_ARG(state->cmp_fcinfo, 0) = state->vec_mins[i];
        FC_ARG(state->cmp_fcinfo, 1) = currentVals[i];
        state->cmp_fcinfo->isnull = false;
        compareResult = FunctionCallInvoke(state->cmp_fcinfo);
        if (state->cmp_fcinfo->isnull) {
          // delegate function returned no result
          ereport(ERROR, (errmsg("The delegate comparison function returned a NULL result on element %d", i)));
        } else if (DatumGetInt32(compareResult) > 0) {
          oldContext = MemoryContextSwitchTo(aggContext); {
            if (!elemTypeByValue) {
              pfree(DatumGetPointer(state->vec_mins[i]));
            }
            state->vec_mins[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
          } MemoryContextSwitchTo(oldContext);
        }

        // execute delegate comparison function for max
        FC_ARG(state->cmp_fcinfo, 0) = state->vec_maxes[i];
        FC_ARG(state->cmp_fcinfo, 1) = currentVals[i];
        state->cmp_fcinfo->isnull = false;
        compareResult = FunctionCallInvoke(state->cmp_fcinfo);
        if (state->cmp_fcinfo->isnull) {
          // delegate function returned no result
          ereport(ERROR, (errmsg("The delegate comparison function returned a NULL result on element %d", i)));
        } else if (DatumGetInt32(compareResult) < 0) {
          oldContext = MemoryContextSwitchTo(aggContext); {
            if (!elemTypeByValue) {
              pfree(DatumGetPointer(state->vec_maxes[i]));
            }
            state->vec_maxes[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
          } MemoryContextSwitchTo(oldContext);
        }
      }
      
      // execute delegate transition function
      FC_ARG(state->transfn_fcinfo, 0) = state->vec_states[i];
      FC_ARG(state->transfn_fcinfo, 1) = currentVals[i];
      state->transfn_fcinfo->isnull = false;
      state->vec_states[i] = (*accum_func) (state->transfn_fcinfo);
      if (state->transfn_fcinfo->isnull) {
        // delegate function returned no state
        ereport(ERROR, (errmsg("The delegate transition function returned a NULL aggregate state on element %d", i)));
      }

      // increment non-null count
      state->vec_counts[i]++;
    }
  }
  PG_RETURN_POINTER(state);
}
