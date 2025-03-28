/* aggs_for_vecs--1.3.2--1.4.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "ALTER EXTENSION aggs_for_vecs UPDATE" to load this file. \quit

-- elements

CREATE OR REPLACE FUNCTION
vec_elements(anyarray, integer[])
RETURNS anyarray
AS 'aggs_for_vecs', 'vec_elements_from_int'
LANGUAGE c;

