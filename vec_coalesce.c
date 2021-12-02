
Datum vec_coalesce(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_coalesce);

/**
 * Coalesce elements in an array to a non-null value.
 *
 * This function takes an array of n elements plus a non-null value of the same type
 * as the array. It returns a new array with any NULL elements of the input array
 * replaced by the given non-null value.
 */
Datum
vec_coalesce(PG_FUNCTION_ARGS)
{
  Oid scalarTypeId = get_fn_expr_argtype(fcinfo->flinfo, 1);
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int inputLength;
  ArrayType *inputArray, *retArray;
  Datum *inputContent, scalarContent, *retContent = 0;
  bool *inputNulls, *retNulls;
  int i, j;
  int dims[1];
  int lbs[1];

  if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
    PG_RETURN_NULL();
  }

  inputArray = PG_GETARG_ARRAYTYPE_P(0);

  if (ARR_NDIM(inputArray) == 0) {
    PG_RETURN_NULL();
  }
  if (ARR_NDIM(inputArray) > 1) {
    ereport(ERROR, (errmsg("vec_coalesce: one-dimensional array is required")));
  }

  elemTypeId = ARR_ELEMTYPE(inputArray);

  if (elemTypeId != INT2OID &&
      elemTypeId != INT4OID &&
      elemTypeId != INT8OID &&
      elemTypeId != FLOAT4OID &&
      elemTypeId != FLOAT8OID &&
      elemTypeId != NUMERICOID) {
    ereport(ERROR, (errmsg("vec_coalesce input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC")));
  }
  if (elemTypeId != scalarTypeId) {
    ereport(ERROR, (errmsg("vec_coalesce input array and scalar must be the same type")));
  }

  get_typlenbyvalalign(scalarTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(inputArray, scalarTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &inputContent, &inputNulls, &inputLength);

  scalarContent = PG_GETARG_DATUM(1);

  for (i = 0; i < inputLength; i++) {
    if (inputNulls[i]) {
      if (!retContent) {
        // lazy-init return structures now
        retContent = palloc0(sizeof(Datum) * inputLength);
        retNulls = palloc0(sizeof(bool) * inputLength);

        // back-fill skipped values as needed
        for (j = 0; j < i; j++) {
          retNulls[j] = false;
          retContent[j] = inputContent[j];
        }
      }
      retNulls[i] = false;
      retContent[i] = scalarContent;
    } else if (retContent) {
      retNulls[i] = false;
      retContent[i] = inputContent[i];
    }
  }

  // if we found no NULL elements; simply return the input to save a few cycles
  if (!retContent) PG_RETURN_ARRAYTYPE_P(inputArray);

  dims[0] = inputLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      scalarTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}

