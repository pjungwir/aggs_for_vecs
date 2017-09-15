/* aggs_for_vecs--1.1.1.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION aggs_for_vecs" to load this file. \quit



CREATE OR REPLACE FUNCTION
vec_without_outliers(anyarray, anyarray, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_without_outliers'
LANGUAGE c;



CREATE OR REPLACE FUNCTION
vec_to_count_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_count_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_count_finalfn(internal, anyarray)
RETURNS bigint[]
AS 'aggs_for_vecs', 'vec_to_count_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_count(anyarray) (
  sfunc = vec_to_count_transfn,
  stype = internal,
  finalfunc = vec_to_count_finalfn,
  finalfunc_extra
);



CREATE OR REPLACE FUNCTION
vec_to_sum_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_sum_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_sum_finalfn(internal, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_to_sum_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_sum(anyarray) (
  sfunc = vec_to_sum_transfn,
  stype = internal,
  finalfunc = vec_to_sum_finalfn,
  finalfunc_extra
);



CREATE OR REPLACE FUNCTION
vec_to_mean_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_mean_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_mean_finalfn(internal, anyarray)
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_mean_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_mean(anyarray) (
  sfunc = vec_to_mean_transfn,
  stype = internal,
  finalfunc = vec_to_mean_finalfn,
  finalfunc_extra
);



CREATE OR REPLACE FUNCTION
vec_to_var_samp_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_var_samp_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_var_samp_finalfn(internal, anyarray)
RETURNS float[]
AS 'aggs_for_vecs', 'vec_to_var_samp_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_var_samp(anyarray) (
  sfunc = vec_to_var_samp_transfn,
  stype = internal,
  finalfunc = vec_to_var_samp_finalfn,
  finalfunc_extra
);



CREATE OR REPLACE FUNCTION
vec_to_min_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_min_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_min_finalfn(internal, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_to_min_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_min(anyarray) (
  sfunc = vec_to_min_transfn,
  stype = internal,
  finalfunc = vec_to_min_finalfn,
  finalfunc_extra
);



CREATE OR REPLACE FUNCTION
vec_to_max_transfn(internal, anyarray)
RETURNS internal
AS 'aggs_for_vecs', 'vec_to_max_transfn'
LANGUAGE c;

CREATE OR REPLACE FUNCTION
vec_to_max_finalfn(internal, anyarray)
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_to_max_finalfn'
LANGUAGE c;

CREATE AGGREGATE vec_to_max(anyarray) (
  sfunc = vec_to_max_transfn,
  stype = internal,
  finalfunc = vec_to_max_finalfn,
  finalfunc_extra
);
