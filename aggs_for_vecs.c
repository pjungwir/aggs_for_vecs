#include <postgres.h>
#include <fmgr.h>
#include <catalog/pg_type.h>
#include <utils/datum.h>
#include <utils/array.h>
#include <utils/builtins.h>
#include <utils/lsyscache.h>
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


#include "util.c"
#include "pad_vec.c"
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

