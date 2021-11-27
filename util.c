/*
 * check to see if a float4/8 val has underflowed or overflowed
 * (copied from backend/utils/adt/float.c)
 */
#define CHECKFLOATVAL(val, inf_is_valid, zero_is_valid)     \
do {                              \
  if (isinf(val) && !(inf_is_valid))              \
    ereport(ERROR,                      \
        (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE), \
      errmsg("value out of range: overflow")));       \
                                \
  if ((val) == 0.0 && !(zero_is_valid))           \
    ereport(ERROR,                      \
        (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE), \
      errmsg("value out of range: underflow")));      \
} while(0)

typedef union pgnum {
  int16 i16;
  int32 i32;
  int64 i64;
  float4 f4;
  float8 f8;
  Numeric num;
} pgnum;

typedef struct VecArrayBuildState {
  ArrayBuildState state;
  Oid inputElementType;
  pgnum *vecvalues;     // The current aggregate result for each position.
  uint32 *veccounts;     // How many values in this position are not null.
  pgnum *vectmpvalues;  // Intermediate results if we need them.
} VecArrayBuildState;


VecArrayBuildState *
initVecArrayResultWithNulls(Oid input_element_type, Oid state_element_type, MemoryContext rcontext, int arLen);

VecArrayBuildState *
initVecArrayResultWithNulls(Oid input_element_type, Oid state_element_type, MemoryContext rcontext, int arLen) {
  VecArrayBuildState *astate;
  int i;

  astate = (VecArrayBuildState *)MemoryContextAlloc(rcontext, sizeof(VecArrayBuildState));
  astate->state.mcontext = rcontext;
#if PG_VERSION_NUM >= 90500
  astate->state.private_cxt = false;
#endif
  astate->state.alen = arLen;
  astate->state.dvalues = (Datum *)
    MemoryContextAlloc(rcontext, astate->state.alen * sizeof(Datum));
  astate->state.dnulls = (bool *)
    MemoryContextAlloc(rcontext, astate->state.alen * sizeof(bool));
  for (i = 0; i < arLen; i++) {
    astate->state.dnulls[i] = true;
  }
  astate->inputElementType = input_element_type;
  astate->vecvalues = (pgnum *)
    MemoryContextAlloc(rcontext, astate->state.alen * sizeof(pgnum));
  astate->veccounts = (uint32 *)
    MemoryContextAlloc(rcontext, astate->state.alen * sizeof(uint32));
  memset(astate->veccounts, 0, astate->state.alen * sizeof(uint32));
  astate->vectmpvalues = (pgnum *)
    MemoryContextAlloc(rcontext, astate->state.alen * sizeof(pgnum));
  
  astate->state.nelems = arLen;
  astate->state.element_type = state_element_type;
  get_typlenbyvalalign(state_element_type,
      &astate->state.typlen,
      &astate->state.typbyval,
      &astate->state.typalign);

  return astate;
}

ArrayBuildState *
initArrayResultWithNulls(Oid element_type, MemoryContext rcontext, int arLen);

ArrayBuildState *
initArrayResultWithNulls(Oid element_type, MemoryContext rcontext, int arLen) {
  ArrayBuildState *astate;
  int i;

  astate = (ArrayBuildState *)MemoryContextAlloc(rcontext, sizeof(ArrayBuildState));
  astate->mcontext = rcontext;
#if PG_VERSION_NUM >= 90500
  astate->private_cxt = false;
#endif
  astate->alen = arLen;
  astate->dvalues = (Datum *)
    MemoryContextAlloc(rcontext, astate->alen * sizeof(Datum));
  astate->dnulls = (bool *)
    MemoryContextAlloc(rcontext, astate->alen * sizeof(bool));
  for (i = 0; i < arLen; i++) {
    astate->dnulls[i] = true;
  }
  
  astate->nelems = arLen;
  astate->element_type = element_type;
  get_typlenbyvalalign(element_type,
      &astate->typlen,
      &astate->typbyval,
      &astate->typalign);

  return astate;
}
