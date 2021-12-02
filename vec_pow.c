Datum vec_pow_with_vec(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_pow_with_vec);

/**
 * Does element-wise exponentiation between two vectors.
 *
 * Both vectors must be the same length,
 * and returns a vector of that length.
 *
 * If either vector contains a NULL,
 * the result is NULL for that position.
 * If either input is NULL itself,
 * the result is NULL.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_pow_with_vec(PG_FUNCTION_ARGS)
{
  Oid elemTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int lhsLength;
  ArrayType *lhsArray, *rhsArray, *retArray;
  Datum *lhsContent, *rhsContent, *retContent;
  bool *lhsNulls, *rhsNulls, *retNulls;
  int i;
  int dims[1];
  int lbs[1];

  if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
    PG_RETURN_NULL();
  }

  lhsArray = PG_GETARG_ARRAYTYPE_P(0);
  rhsArray = PG_GETARG_ARRAYTYPE_P(1);

  if (ARR_NDIM(lhsArray) == 0 || (ARR_NDIM(rhsArray) == 0)) {
    PG_RETURN_NULL();
  }
  if (ARR_NDIM(lhsArray) > 1 || (ARR_NDIM(rhsArray) > 1)) {
    ereport(ERROR, (errmsg("vec_pow: one-dimensional arrays are required")));
  }

  elemTypeId = ARR_ELEMTYPE(lhsArray);

  if (elemTypeId != INT2OID &&
      elemTypeId != INT4OID &&
      elemTypeId != INT8OID &&
      elemTypeId != FLOAT4OID &&
      elemTypeId != FLOAT8OID &&
      elemTypeId != NUMERICOID) {
    ereport(ERROR, (errmsg("vec_pow input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC")));
  }
  if (elemTypeId != ARR_ELEMTYPE(rhsArray)) {
    ereport(ERROR, (errmsg("vec_pow input arrays must be the same type")));
  }

  get_typlenbyvalalign(elemTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);

  deconstruct_array(lhsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &lhsContent, &lhsNulls, &lhsLength);
  deconstruct_array(rhsArray, elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &rhsContent, &rhsNulls, &lhsLength);

  retContent = palloc0(sizeof(Datum) * lhsLength);
  retNulls = palloc0(sizeof(bool) * lhsLength);

  for (i = 0; i < lhsLength; i++) {
    if (lhsNulls[i] || rhsNulls[i]) {
      retNulls[i] = true;
      continue;
    }
    retNulls[i] = false;
    switch(elemTypeId) {
      case INT2OID:
        retContent[i] = Int16GetDatum(powl(DatumGetInt16(lhsContent[i]), DatumGetInt16(rhsContent[i])));
        break;
      case INT4OID:
        retContent[i] = Int32GetDatum(powl(DatumGetInt32(lhsContent[i]), DatumGetInt32(rhsContent[i])));
        break;
      case INT8OID:
        retContent[i] = Int64GetDatum(powl(DatumGetInt64(lhsContent[i]), DatumGetInt64(rhsContent[i])));
        break;
      case FLOAT4OID:
        retContent[i] = Float4GetDatum(powl(DatumGetFloat4(lhsContent[i]), DatumGetFloat4(rhsContent[i])));
        break;
      case FLOAT8OID:
        retContent[i] = Float8GetDatum(powl(DatumGetFloat8(lhsContent[i]), DatumGetFloat8(rhsContent[i])));
        break;
      case NUMERICOID:
        retContent[i] = DirectFunctionCall2(numeric_power, lhsContent[i], rhsContent[i]);
        break;
    }
  }

  dims[0] = lhsLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      elemTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}



Datum vec_pow_with_scalar(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_pow_with_scalar);

/**
 * Raises a scalar to the power of all elements in a given vector,
 * or vice versa.
 *
 * If the vector contains a NULL,
 * the result is NULL for that position.
 *
 * If the vector itself is NULL,
 * the result is NULL.
 *
 * If the scalar is NULL,
 * then all elements of the resulting vector are NULL.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_pow_with_scalar(PG_FUNCTION_ARGS)
{
  Oid elemTypeId1 = get_fn_expr_argtype(fcinfo->flinfo, 0);
  Oid elemTypeId2 = get_fn_expr_argtype(fcinfo->flinfo, 1);
  Oid scalarTypeId;
  int16 elemTypeWidth;
  bool elemTypeByValue;
  char elemTypeAlignmentCode;
  int inputLength;
  ArrayType *inputArray, *retArray;
  Datum *inputContent, scalarContent, *retContent;
  bool *inputNulls, scalarNull, *retNulls;
  int arrayPos, scalarPos;
  int i;
  pgnum scalar;
  int dims[1];
  int lbs[1];

  if (!OidIsValid(elemTypeId1) || !OidIsValid(elemTypeId2)) elog(ERROR, "could not determine data type of input");

  if (elemTypeId1 == INT2OID ||
      elemTypeId1 == INT4OID ||
      elemTypeId1 == INT8OID ||
      elemTypeId1 == FLOAT4OID ||
      elemTypeId1 == FLOAT8OID ||
      elemTypeId1 == NUMERICOID) {
    scalarPos = 0;
    arrayPos = 1;
    scalarTypeId = elemTypeId1;
  } else if (elemTypeId2 == INT2OID ||
             elemTypeId2 == INT4OID ||
             elemTypeId2 == INT8OID ||
             elemTypeId2 == FLOAT4OID ||
             elemTypeId2 == FLOAT8OID ||
             elemTypeId2 == NUMERICOID) {
    scalarPos = 1;
    arrayPos = 0;
    scalarTypeId = elemTypeId2;
  } else {
    ereport(ERROR, (errmsg("vec_pow scalar operand must be a numeric type")));
  }

  if (PG_ARGISNULL(arrayPos)) {
    PG_RETURN_NULL();
  }
  inputArray = PG_GETARG_ARRAYTYPE_P(arrayPos);
  scalarNull = PG_ARGISNULL(scalarPos);

  if (ARR_ELEMTYPE(inputArray) != scalarTypeId) {
    ereport(ERROR, (errmsg("vec_pow array elements and scalar operand must be the same type")));
  }

  if (ARR_NDIM(inputArray) != 1) {
    ereport(ERROR, (errmsg("vec_pow: one-dimensional arrays are required")));
  }

  get_typlenbyvalalign(scalarTypeId, &elemTypeWidth, &elemTypeByValue, &elemTypeAlignmentCode);
  deconstruct_array(inputArray, scalarTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode,
      &inputContent, &inputNulls, &inputLength);

  retContent = palloc0(sizeof(Datum) * inputLength);
  retNulls = palloc0(sizeof(bool) * inputLength);

  if (!scalarNull) {
    scalarContent = PG_GETARG_DATUM(scalarPos);
    switch(scalarTypeId) {
      case INT2OID:
        scalar.i16 = DatumGetInt16(scalarContent);
        break;
      case INT4OID:
        scalar.i32 = DatumGetInt32(scalarContent);
        break;
      case INT8OID:
        scalar.i64 = DatumGetInt64(scalarContent);
        break;
      case FLOAT4OID:
        scalar.f4 = DatumGetFloat4(scalarContent);
        break;
      case FLOAT8OID:
        scalar.f8 = DatumGetFloat8(scalarContent);
        break;
      case NUMERICOID:
        scalar.num = DatumGetNumeric(scalarContent);
        break;
    }
  }
  for (i = 0; i < inputLength; i++) {
    if (scalarNull || inputNulls[i]) {
      retNulls[i] = true;
      continue;
    }
    retNulls[i] = false;
    if (scalarPos == 0) {
      switch(scalarTypeId) {
        case INT2OID:
          retContent[i] = Int16GetDatum(powl(scalar.i16, DatumGetInt16(inputContent[i])));
          break;
        case INT4OID:
          retContent[i] = Int32GetDatum(powl(scalar.i32, DatumGetInt32(inputContent[i])));
          break;
        case INT8OID:
          retContent[i] = Int64GetDatum(powl(scalar.i64, DatumGetInt64(inputContent[i])));
          break;
        case FLOAT4OID:
          retContent[i] = Float4GetDatum(powl(scalar.f4, DatumGetFloat4(inputContent[i])));
          break;
        case FLOAT8OID:
          retContent[i] = Float8GetDatum(powl(scalar.f8, DatumGetFloat8(inputContent[i])));
          break;
        case NUMERICOID:
          retContent[i] = DirectFunctionCall2(numeric_power, NumericGetDatum(scalar.num), inputContent[i]);
          break;
      }
    } else {
      switch(scalarTypeId) {
        case INT2OID:
          retContent[i] = Int16GetDatum(powl(DatumGetInt16(inputContent[i]), scalar.i16));
          break;
        case INT4OID:
          retContent[i] = Int32GetDatum(powl(DatumGetInt32(inputContent[i]), scalar.i32));
          break;
        case INT8OID:
          retContent[i] = Int64GetDatum(powl(DatumGetInt64(inputContent[i]), scalar.i64));
          break;
        case FLOAT4OID:
          retContent[i] = Float4GetDatum(powl(DatumGetFloat4(inputContent[i]), scalar.f4));
          break;
        case FLOAT8OID:
          retContent[i] = Float8GetDatum(powl(DatumGetFloat8(inputContent[i]), scalar.f8));
          break;
        case NUMERICOID:
          retContent[i] = DirectFunctionCall2(numeric_power, inputContent[i], NumericGetDatum(scalar.num));
          break;
      }
    }
  }

  dims[0] = inputLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      scalarTypeId, elemTypeWidth, elemTypeByValue, elemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}

