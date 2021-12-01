#include <postgres.h>
#include <fmgr.h>
#include <catalog/pg_type.h>
#include <utils/datum.h>
#include <utils/array.h>
#include <utils/builtins.h>
#include <utils/lsyscache.h>
#include <utils/memutils.h>
#include <utils/typcache.h>
#if PG_VERSION_NUM >= 90500
#include <utils/arrayaccess.h>
#endif
#include <math.h>
#include <utils/datum.h>
#include <utils/numeric.h>
#if PG_VERSION_NUM >= 100000
#include <utils/fmgrprotos.h>
#endif

PG_MODULE_MAGIC;

void
_PG_init(void);

void
_PG_fini(void);

// some cached Numeric values to speed up certain operations
static Datum NUMERIC_ZERO;
static Datum NUMERIC_ONE;

void
_PG_init(void)
{
  MemoryContext old;
  old = MemoryContextSwitchTo(TopMemoryContext);
  NUMERIC_ZERO = DirectFunctionCall1(int4_numeric, Int32GetDatum(0));
  NUMERIC_ONE = DirectFunctionCall1(int4_numeric, Int32GetDatum(1));
  MemoryContextSwitchTo(old);
}

void
_PG_fini(void)
{
  MemoryContext old;
  old = MemoryContextSwitchTo(TopMemoryContext);
  pfree(DatumGetPointer(NUMERIC_ZERO));
  pfree(DatumGetPointer(NUMERIC_ONE));
  MemoryContextSwitchTo(old);
}

#include "util.c"
#include "pad_vec.c"
#include "vec_add.c"
#include "vec_sub.c"
#include "vec_mul.c"
#include "vec_div.c"
#include "vec_pow.c"
#include "vec_trim_scale.c"
#include "vec_without_outliers.c"
#include "vec_to_count.c"
#include "vec_to_sum.c"
#include "vec_to_mean.c"
#include "vec_to_mean_numeric.c"
// #include "vec_to_median.c"
// #include "vec_to_mode.c"
#include "vec_to_max.c"
#include "vec_to_min.c"
// #include "vec_to_min_max.c"
// #include "vec_to_percentile.c"
// #include "vec_to_percentiles.c"
#include "vec_to_var_samp.c"
// #include "vec_to_skewness.c"
// #include "vec_to_kurtosis.c"
#include "hist_2d.c"
#include "hist_md.c"

