# 1.3.0

- Support up to Postgres 14.
- Added support for `NUMERIC` (aka `DECIMAL`) to most functions.
- Added `vec_weighted_mean`.
- Added non-aggregate functions like `vec_add` etc.
- Added `vec_agg_stat` to compute several aggregates at once.
- Added `vec_to_first` and `vec_to_last`.
- Added helper functions `pad_vec`, `vec_coalesce`, `vec_trim_scale`.
- Converted tests to `pg_regress`.

# 1.2.1

Updated documentation.

# 1.2.0

Added `hist_2d` and `hist_md` functions.

# 1.1.1

Fixed precision errors in `vec_to_var_samp` with many input rows.

# 1.1.0

Added `vec_to_sum` function.

# 1.0.1

Fixed array out-of-bounds access.

Added support for Postgres 9.4.

# 1.0.0

Initial release.
