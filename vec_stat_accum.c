
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
  Datum compareResult;
  PGFunction accum_func;
  PGFunction cmp_func;

  if (!AggCheckCallContext(fcinfo, &aggContext)) {
    elog(ERROR, "vec_stat_agg called in non-aggregate context");
  }

  state = PG_ARGISNULL(0) ? NULL : (VecAggAccumState *)PG_GETARG_POINTER(0);

  if (PG_ARGISNULL(1)) {
    // just return the current state unchanged (possibly still NULL)
    PG_RETURN_POINTER(state);
  }
  currentArray = PG_GETARG_ARRAYTYPE_P(1);

  if (state == NULL) {
    elemTypeId = ARR_ELEMTYPE(currentArray);
    if (ARR_NDIM(currentArray) != 1) {
      ereport(ERROR, (errmsg("One-dimensional arrays are required")));
    }
    arrayLength = (ARR_DIMS(currentArray))[0];
    state = initVecAggAccumState(elemTypeId, aggContext, arrayLength);
    // Set up the delegate aggregate transition/compare function calls
    state->transfn_fcinfo = HEAP_FCINFO(aggContext,  2);
    state->cmp_fcinfo = HEAP_FCINFO(aggContext,  2);
    switch(elemTypeId) {
      // TODO: support other number types
      case NUMERICOID:
        // the numeric_avg_accum supports numeric_avg and numeric_sum final functions
        InitFunctionCallInfoData(*state->transfn_fcinfo, NULL, 2, fcinfo->fncollation, fcinfo->context, fcinfo->resultinfo);
        InitFunctionCallInfoData(*state->cmp_fcinfo, NULL, 2, InvalidOid, NULL, NULL);
        break;
      default:
        elog(ERROR, "Unknown array element type");
    }
    FC_NULL(state->transfn_fcinfo, 1) = false;
    FC_NULL(state->cmp_fcinfo, 0) = false;
    FC_NULL(state->cmp_fcinfo, 1) = false;
  } else {
    elemTypeId = state->elementType;
    arrayLength = state->nelems;
  }
  switch(elemTypeId) {
    // TODO: support other number types
    case NUMERICOID:
      accum_func = numeric_avg_accum;
      cmp_func = numeric_cmp;
      break;
    default:
      elog(ERROR, "Unknown array element type");
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(currentArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &currentVals, &currentNulls, &currentLength);
  if (currentLength != arrayLength) {
    ereport(ERROR, (errmsg("All arrays must be the same length, but we got %d vs %d", currentLength, arrayLength)));
  }

  // for each input element, delegate to 
  for (i = 0; i < arrayLength; i++) {
    if (currentNulls[i]) {
      // do nothing: nulls can't change the result.
    } else {
      if (!state->vec_counts[i]) {
        // first call to delegate aggregate transition, so must init transfn_fcinfo if not already
        FC_NULL(state->transfn_fcinfo, 0) = true;

        // first non-null element set up as initial min/max values
        oldContext = MemoryContextSwitchTo(aggContext); {
          state->vec_mins[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
          state->vec_maxes[i] = state->vec_mins[i];
        } MemoryContextSwitchTo(oldContext);
      } else {
        FC_NULL(state->transfn_fcinfo, 0) = false;

        // execute delegate comparison function for min
        FC_ARG(state->cmp_fcinfo, 0) = state->vec_mins[i];
        FC_ARG(state->cmp_fcinfo, 1) = currentVals[i];
        state->cmp_fcinfo->isnull = false;
        compareResult = (*cmp_func) (state->cmp_fcinfo);
        if (state->cmp_fcinfo->isnull) {
          // delegate function returned no result
          ereport(ERROR, (errmsg("The delegate comparison function returned a NULL result on element %d", i)));
        } else if (DatumGetInt32(compareResult) > 0) {
          oldContext = MemoryContextSwitchTo(aggContext); {
            state->vec_mins[i] = datumCopy(currentVals[i], elemTypeByValue, elemTypeWidth);
          } MemoryContextSwitchTo(oldContext);
        }

        // execute delegate comparison function for max
        FC_ARG(state->cmp_fcinfo, 0) = state->vec_maxes[i];
        FC_ARG(state->cmp_fcinfo, 1) = currentVals[i];
        state->cmp_fcinfo->isnull = false;
        compareResult = (*cmp_func) (state->cmp_fcinfo);
        if (state->cmp_fcinfo->isnull) {
          // delegate function returned no result
          ereport(ERROR, (errmsg("The delegate comparison function returned a NULL result on element %d", i)));
        } else if (DatumGetInt32(compareResult) < 0) {
          oldContext = MemoryContextSwitchTo(aggContext); {
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
