-- first int2
SELECT vec_to_first(smallints ORDER BY sensor_id) AS firsts
FROM measurements;

-- first int4
SELECT vec_to_first(ints ORDER BY sensor_id) AS firsts
FROM measurements;

-- first int8
SELECT vec_to_first(bigints ORDER BY sensor_id) AS firsts
FROM measurements;

-- first float4
SELECT vec_to_first(reals ORDER BY sensor_id) AS firsts
FROM measurements;

-- first float8
SELECT vec_to_first(floats ORDER BY sensor_id) AS firsts
FROM measurements;

-- first numeric
SELECT vec_to_first(nums ORDER BY sensor_id) AS firsts
FROM measurements;

-- first numeric 2
SELECT vec_to_first(data_i ORDER BY ts) AS firsts
FROM measurements2;

-- first numeric 3
SELECT vec_to_first(pad_vec(data_a, 3) ORDER BY ts) AS firsts
FROM measurements2;

-- first text
SELECT vec_to_first(vals) FROM (VALUES (ARRAY[NULL,'a','foo']::text[]), (ARRAY['one','b','bar']::text[]), (ARRAY['two','c',NULL]::text[])) t(vals);
