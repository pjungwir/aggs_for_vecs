Datum vec_elements_from_int(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(vec_elements_from_int);

/**
 * Picks out just the indices you ask for.
 * Indexes are 1-based, just like how you'd normally index into a Postgres array.
 *
 * by Paul A. Jungwirth
 */
Datum
vec_elements_from_int(PG_FUNCTION_ARGS)
{
  Oid lhsElemTypeId, rhsElemTypeId;
  int16 lhsElemTypeWidth, rhsElemTypeWidth;
  bool lhsElemTypeByValue, rhsElemTypeByValue;
  char lhsElemTypeAlignmentCode, rhsElemTypeAlignmentCode;
  int lhsLength, rhsLength;
  ArrayType *lhsArray, *rhsArray, *retArray;
  Datum *lhsContent, *rhsContent, *retContent;
  bool *lhsNulls, *rhsNulls, *retNulls;
  int i;
  int dims[1];
  int lbs[1];
  int32 index;

  if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
    PG_RETURN_NULL();
  }

  lhsArray = PG_GETARG_ARRAYTYPE_P(0);
  rhsArray = PG_GETARG_ARRAYTYPE_P(1);

  if (ARR_NDIM(lhsArray) > 1 || (ARR_NDIM(rhsArray) > 1)) {
    ereport(ERROR, (errmsg("vec_elements: one-dimensional arrays are required")));
  }

  lhsElemTypeId = ARR_ELEMTYPE(lhsArray);
  rhsElemTypeId = ARR_ELEMTYPE(rhsArray);

  if (rhsElemTypeId != INT4OID) {
    ereport(ERROR, (errmsg("vec_elements index list must be array of INTEGER")));
  }

  get_typlenbyvalalign(lhsElemTypeId, &lhsElemTypeWidth, &lhsElemTypeByValue, &lhsElemTypeAlignmentCode);
  get_typlenbyvalalign(rhsElemTypeId, &rhsElemTypeWidth, &rhsElemTypeByValue, &rhsElemTypeAlignmentCode);

  deconstruct_array(lhsArray, lhsElemTypeId, lhsElemTypeWidth, lhsElemTypeByValue, lhsElemTypeAlignmentCode,
      &lhsContent, &lhsNulls, &lhsLength);
  deconstruct_array(rhsArray, rhsElemTypeId, rhsElemTypeWidth, rhsElemTypeByValue, rhsElemTypeAlignmentCode,
      &rhsContent, &rhsNulls, &rhsLength);

  retContent = palloc0(sizeof(Datum) * rhsLength);
  retNulls = palloc0(sizeof(bool) * rhsLength);

  for (i = 0; i < rhsLength; i++) {
    if (rhsNulls[i]) {
      retNulls[i] = true;
      continue;
    }
    index = DatumGetInt32(rhsContent[i]);
    if (index < 1) {
      ereport(ERROR, (errmsg("vec_elements indices can't be less than 1, but got %d", index)));
    }

    if (index > lhsLength) {
      retNulls[i] = true;
      continue;
    }
    retNulls[i] = false;
    retContent[i] = lhsContent[index - 1];
  }

  dims[0] = rhsLength;
  lbs[0] = 1;

  retArray = construct_md_array(retContent, retNulls, 1, dims, lbs,
      lhsElemTypeId, lhsElemTypeWidth, lhsElemTypeByValue, lhsElemTypeAlignmentCode);

  PG_RETURN_ARRAYTYPE_P(retArray);
}
