/* aggs_for_vecs--1.3.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION aggs_for_vecs" to load this file. \quit



-- pad_vec

CREATE OR REPLACE FUNCTION
pad_vec(smallint[], int)
RETURNS smallint[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
pad_vec(int[], int)
RETURNS int[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
pad_vec(bigint[], int)
RETURNS bigint[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
pad_vec(real[], int)
RETURNS real[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
pad_vec(float[], int)
RETURNS float[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
pad_vec(numeric[], int)
RETURNS numeric[]
AS 'aggs_for_vecs', 'pad_vec'
LANGUAGE c;



-- vec_trim_scale

CREATE OR REPLACE FUNCTION
vec_trim_scale(numeric[])
RETURNS numeric[]
AS 'aggs_for_vecs', 'vec_trim_scale'
LANGUAGE c;



-- vec_without_outliers

CREATE OR REPLACE FUNCTION
vec_without_outliers(smallint[], smallint[], smallint[])
RETURNS smallint[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
vec_without_outliers(int[], int[], int[])
RETURNS int[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
vec_without_outliers(bigint[], bigint[], bigint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
vec_without_outliers(real[], real[], real[])
RETURNS real[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
vec_without_outliers(float[], float[], float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;
CREATE OR REPLACE FUNCTION
vec_without_outliers(numeric[], numeric[], numeric[])
RETURNS numeric[]
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;



-- vec_to_count

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, smallint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(smallint[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, int[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(int[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, bigint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(bigint[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, real[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(real[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, float[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(float[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, numeric[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(numeric[]) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);



-- vec_to_sum

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, smallint[])
RETURNS smallint[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(smallint[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, int[])
RETURNS int[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(int[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, bigint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(bigint[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, real[])
RETURNS real[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(real[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(float[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, numeric[])
RETURNS numeric[]
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(numeric[]) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);



-- vec_to_mean

CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, smallint[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(smallint[]) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, int[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(int[]) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, bigint[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(bigint[]) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, real[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(real[]) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(float[]) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_mean_numeric_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_numeric_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_numeric_finalfn(internal, numeric[])
RETURNS numeric[] -- sic: not float[] like the others
AS 'aggs_for_vecs', 'vec_to_mean_numeric_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(numeric[]) (
  sfunc = vec_to_mean_numeric_transfn,
  stype = internal,
  finalfunc = vec_to_mean_numeric_finalfn,
  finalfunc_extra
);



-- vec_to_var_samp

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, smallint[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(smallint[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, int[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(int[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, bigint[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(bigint[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, real[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(real[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(float[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, numeric[])
RETURNS numeric[] -- sic: not float[] like the others
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(numeric[]) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);



-- vec_to_min

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, smallint[])
RETURNS smallint[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(smallint[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, int[])
RETURNS int[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(int[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, bigint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(bigint[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, real[])
RETURNS real[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(real[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(float[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, numeric[])
RETURNS numeric[]
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(numeric[]) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);



-- vec_to_max

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, smallint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, smallint[])
RETURNS smallint[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(smallint[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, int[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, int[])
RETURNS int[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(int[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, bigint[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, bigint[])
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(bigint[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, real[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, real[])
RETURNS real[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(real[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, float[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, float[])
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(float[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, numeric[])
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, numeric[])
RETURNS numeric[]
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(numeric[]) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);



-- hist_2d

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, smallint, smallint, smallint, smallint, smallint, smallint, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, smallint, smallint, smallint, smallint, smallint, smallint, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(smallint, smallint, smallint, smallint, smallint, smallint, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, int, int, int, int, int, int, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, int, int, int, int, int, int, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(int, int, int, int, int, int, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, bigint, bigint, bigint, bigint, bigint, bigint, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, bigint, bigint, bigint, bigint, bigint, bigint, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(bigint, bigint, bigint, bigint, bigint, bigint, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, real, real, real, real, real, real, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, real, real, real, real, real, real, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(real, real, real, real, real, real, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, float, float, float, float, float, float, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, float, float, float, float, float, float, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(float, float, float, float, float, float, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_2d_transfn(internal, numeric, numeric, numeric, numeric, numeric, numeric, integer, integer)
RETURNS internal
AS 'aggs_for_vecs', 'hist_2d_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_2d_finalfn(internal, numeric, numeric, numeric, numeric, numeric, numeric, integer, integer)
RETURNS integer[][]
AS 'aggs_for_vecs', 'hist_2d_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_2d(numeric, numeric, numeric, numeric, numeric, numeric, integer, integer) (
  sfunc = hist_2d_transfn,
  stype = internal,
  finalfunc = hist_2d_finalfn,
  finalfunc_extra
);



-- hist_md

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, smallint[], integer[], smallint[], smallint[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, smallint[], integer[], smallint[], smallint[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(smallint[], integer[], smallint[], smallint[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, int[], integer[], int[], int[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, int[], integer[], int[], int[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(int[], integer[], int[], int[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, bigint[], integer[], bigint[], bigint[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, bigint[], integer[], bigint[], bigint[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(bigint[], integer[], bigint[], bigint[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, real[], integer[], real[], real[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, real[], integer[], real[], real[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(real[], integer[], real[], real[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, float[], integer[], float[], float[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, float[], integer[], float[], float[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(float[], integer[], float[], float[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);

CREATE OR REPLACE FUNCTION
hist_md_transfn(internal, numeric[], integer[], numeric[], numeric[], integer[])
RETURNS internal
AS 'aggs_for_vecs', 'hist_md_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
hist_md_finalfn(internal, numeric[], integer[], numeric[], numeric[], integer[])
RETURNS integer[]
AS 'aggs_for_vecs', 'hist_md_finalfn'
LANGUAGE c;

CREATE AGGREGATE hist_md(numeric[], integer[], numeric[], numeric[], integer[]) (
  sfunc = hist_md_transfn,
  stype = internal,
  finalfunc = hist_md_finalfn,
  finalfunc_extra
);



-- add

CREATE OR REPLACE FUNCTION
vec_add(anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_add_with_vec'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_add(anyarray, anyelement)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_add_with_scalar'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_add(anyelement, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_add_with_scalar'
LANGUAGE c;



-- sub

CREATE OR REPLACE FUNCTION
vec_sub(anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_sub_with_vec'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_sub(anyarray, anyelement)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_sub_with_scalar'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_sub(anyelement, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_sub_with_scalar'
LANGUAGE c;



-- mul

CREATE OR REPLACE FUNCTION
vec_mul(anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_mul_with_vec'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_mul(anyarray, anyelement)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_mul_with_scalar'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_mul(anyelement, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_mul_with_scalar'
LANGUAGE c;



-- div

CREATE OR REPLACE FUNCTION
vec_div(anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_div_with_vec'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_div(anyarray, anyelement)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_div_with_scalar'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_div(anyelement, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_div_with_scalar'
LANGUAGE c;



-- pow

CREATE OR REPLACE FUNCTION
vec_pow(anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_pow_with_vec'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_pow(anyarray, anyelement)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_pow_with_scalar'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_pow(anyelement, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_pow_with_scalar'
LANGUAGE c;
