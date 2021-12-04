-- null scalar
SELECT r, pg_typeof(r) FROM (SELECT vec_coalesce(ARRAY[1,2,3]::integer[], NULL)) r(r);
-- ints
SELECT r, pg_typeof(r) FROM (SELECT vec_coalesce(ints, 0) FROM measurements WHERE sensor_id BETWEEN 1 AND 5) r(r);
-- floats
SELECT r, pg_typeof(r) FROM (SELECT vec_coalesce(floats, 0) FROM measurements WHERE sensor_id BETWEEN 1 AND 5) r(r);
--numeric
SELECT r, pg_typeof(r) FROM (SELECT vec_coalesce(nums, 0) FROM measurements WHERE sensor_id BETWEEN 1 AND 5) r(r);
