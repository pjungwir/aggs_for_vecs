
Datum vec_trim_scale(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_trim_scale);

// trim the output scale to drop trailing zeros; in PG13 the trim_scale function is available,
// otherwise manually find the appropriate scale to trim to
Datum
trimScaleNumeric(Datum num);

/**
 * Trims trailing zeros from a numeric array.
 *
 * This function takes an array of n numeric elements and performs a
 * "trim scale" operation on each to remove any trailing zeros by 
 * adjusting their decimal scale.
 */
Datum
vec_trim_scale(PG_FUNCTION_ARGS)
{
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int valsLength;
  ArrayType *valsArray, *retArray;
  Datum *valsContent, *retContent;
  bool *valsNulls, *retNulls;
  int i;
  int dims[1];
  int lbs[1];

  if (PG_ARGISNULL(0)) {
    PG_RETURN_NULL();
  }

  valsArray = PG_GETARG_ARRAYTYPE_P(0);

  if (ARR_NDIM(valsArray) == 0) {
    PG_RETURN_NULL();
  }
  if (ARR_NDIM(valsArray) > 1) {
    ereport(ERROR, (errmsg("vec_trim_scale: one-dimensional arrays are required")));
  }

  get_typlenbyvalalign(NUMERICOID, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(valsArray, NUMERICOID, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &valsContent, &valsNulls, &valsLength);

  retContent = palloc0(sizeof(Datum) * valsLength);
  retNulls = palloc0(sizeof(bool) * valsLength);

  for (i = 0; i < valsLength; i++) {
    if (valsNulls[i]) {
      retNulls[i] = true;
      continue;
    }
    retNulls[i] = false;
    retContent[i] = trimScaleNumeric(valsContent[i]);
  }

  dims[0] = valsLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      NUMERICOID, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}

Datum
trimScaleNumeric(Datum num) {
#if PG_VERSION_NUM >= 130000
   return DirectFunctionCall1(numeric_trim_scale, num);
#else
  char *str;
  int len;
  int j;
  int p;
  // look for number of trailing zeros in string version, then set scale accordingly
  str = DatumGetCString(DirectFunctionCall1(numeric_out, num));
  len = strlen(str);
  p = -1;
  for (j = len - 1; j >= 0; j--) {
    if (str[j] == '0') {
      continue;
    } else if (str[j] == '.') {
        // we found the decimal point; handle all trailing zeros by setting scale to 0
        return DirectFunctionCall2(numeric_trunc, num, Int32GetDatum(p > j ? p - j : 0));
    } else if (p < 0) {
      p = j;
    }
  }
  return num;
#endif
}
