
Datum vec_without_outliers(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_without_outliers);

/**
 * Removes outliers from an array.
 *
 * This function takes an array of n elements
 * plus two n-element filter arrays,
 * and it returns an n-element array,
 * where each element is either the value from the input array,
 * or NULL if the input value exceeds the filters.
 * The first filter array contains minimum values (or NULL for unbounded),
 * and the second filter array contains maximum values (or NULL for unbounded).
 * If the input value is within the min and max (inclusive),
 * it is included in the return value.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_without_outliers(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int valsLength;
  ArrayType *valsArray, *minsArray, *maxesArray, *retArray;
  Datum *valsContent, *minsContent, *maxesContent, *retContent;
  bool *valsNulls, *minsNulls, *maxesNulls, *retNulls;
  int i;
  int dims[1];
  int lbs[1];

  if (PG_ARGISNULL(0)) {
    PG_RETURN_NULL();
  }

  valsArray = PG_GETARG_ARRAYTYPE_P(0);

  if (PG_ARGISNULL(1)) {
    minsArray = NULL;
  } else {
    minsArray = PG_GETARG_ARRAYTYPE_P(1);
  }

  if (PG_ARGISNULL(2)) {
    maxesArray = NULL;
  } else {
    maxesArray = PG_GETARG_ARRAYTYPE_P(2);
  }

  if (ARR_NDIM(valsArray) == 0 || (minsArray && ARR_NDIM(minsArray) == 0) || (maxesArray && ARR_NDIM(maxesArray) == 0)) {
    PG_RETURN_NULL();
  }
  if (ARR_NDIM(valsArray) > 1 || (minsArray && ARR_NDIM(minsArray) > 1) || (maxesArray && ARR_NDIM(maxesArray) > 1)) {
    ereport(ERROR, (errmsg("vec_without_outliers: one-dimensional arrays are required")));
  }

  elemTypeId = ARR_ELEMTYPE(valsArray);

  if (elemTypeId != INT2OID &&
      elemTypeId != INT4OID &&
      elemTypeId != INT8OID &&
      elemTypeId != FLOAT4OID &&
      elemTypeId != FLOAT8OID) {
    ereport(ERROR, (errmsg("vec_without_outliers input must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION")));
  }
  if (minsArray && elemTypeId != ARR_ELEMTYPE(minsArray)) {
    ereport(ERROR, (errmsg("vec_without_outliers mins array must be the same type as input array")));
  }
  if (maxesArray && elemTypeId != ARR_ELEMTYPE(maxesArray)) {
    ereport(ERROR, (errmsg("vec_without_outliers maxes array must be the same type as input array")));
  }

  valsLength = (ARR_DIMS(valsArray))[0];
  if (minsArray && valsLength != (ARR_DIMS(minsArray))[0]) {
    ereport(ERROR, (errmsg("vec_without_outliers mins array must be the same length as input array")));
  }
  if (maxesArray && valsLength != (ARR_DIMS(maxesArray))[0]) {
    ereport(ERROR, (errmsg("vec_without_outliers maxes array must be the same length as input array")));
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);

  deconstruct_array(valsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &valsContent, &valsNulls, &valsLength);
  if (minsArray) {
    deconstruct_array(minsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
        &minsContent, &minsNulls, &valsLength);
  }
  if (maxesArray) {
    deconstruct_array(maxesArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
        &maxesContent, &maxesNulls, &valsLength);
  }

  retContent = palloc0(sizeof(Datum) * valsLength);
  retNulls = palloc0(sizeof(bool) * valsLength);

  for (i = 0; i < valsLength; i++) {
    if (valsNulls[i]) {
      retNulls[i] = true;
      continue;
    }
    switch(elemTypeId) {
      case INT2OID:
        if ((minsArray  && !minsNulls[i]  && DatumGetInt16(valsContent[i]) < DatumGetInt16(minsContent[i])) ||
            (maxesArray && !maxesNulls[i] && DatumGetInt16(valsContent[i]) > DatumGetInt16(maxesContent[i]))) {
          retNulls[i] = true;
        } else {
          retNulls[i] = false;
          retContent[i] = valsContent[i];
        }
        break;
      case INT4OID:
        if ((minsArray  && !minsNulls[i]  && DatumGetInt32(valsContent[i]) < DatumGetInt32(minsContent[i])) ||
            (maxesArray && !maxesNulls[i] && DatumGetInt32(valsContent[i]) > DatumGetInt32(maxesContent[i]))) {
          retNulls[i] = true;
        } else {
          retNulls[i] = false;
          retContent[i] = valsContent[i];
        }
        break;
      case INT8OID:
        if ((minsArray  && !minsNulls[i]  && DatumGetInt32(valsContent[i]) < DatumGetInt32(minsContent[i])) ||
            (maxesArray && !maxesNulls[i] && DatumGetInt32(valsContent[i]) > DatumGetInt32(maxesContent[i]))) {
          retNulls[i] = true;
        } else {
          retNulls[i] = false;
          retContent[i] = valsContent[i];
        }
        break;
      case FLOAT4OID:
        if ((minsArray  && !minsNulls[i]  && DatumGetFloat4(valsContent[i]) < DatumGetFloat4(minsContent[i])) ||
            (maxesArray && !maxesNulls[i] && DatumGetFloat4(valsContent[i]) > DatumGetFloat4(maxesContent[i]))) {
          retNulls[i] = true;
        } else {
          retNulls[i] = false;
          retContent[i] = valsContent[i];
        }
        break;
      case FLOAT8OID:
        if ((minsArray  && !minsNulls[i]  && DatumGetFloat8(valsContent[i]) < DatumGetFloat8(minsContent[i])) ||
            (maxesArray && !maxesNulls[i] && DatumGetFloat8(valsContent[i]) > DatumGetFloat8(maxesContent[i]))) {
          retNulls[i] = true;
        } else {
          retNulls[i] = false;
          retContent[i] = valsContent[i];
        }
        break;
    }
  }

  dims[0] = valsLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}

