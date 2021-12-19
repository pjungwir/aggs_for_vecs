-- last int2
SELECT vec_to_last(smallints ORDER BY sensor_id) AS lasts
FROM measurements;

-- last int4
SELECT vec_to_last(ints ORDER BY sensor_id) AS lasts
FROM measurements;

-- last int8
SELECT vec_to_last(bigints ORDER BY sensor_id) AS lasts
FROM measurements;

-- last float4
SELECT vec_to_last(reals ORDER BY sensor_id) AS lasts
FROM measurements;

-- last float8
SELECT vec_to_last(floats ORDER BY sensor_id) AS lasts
FROM measurements;

-- last numeric
SELECT vec_to_last(nums ORDER BY sensor_id) AS lasts
FROM measurements;

-- last numeric 2
SELECT vec_to_last(data_i ORDER BY ts) AS lasts
FROM measurements2;

-- last numeric 3
SELECT vec_to_last(pad_vec(data_a, 3) ORDER BY ts) AS lasts
FROM measurements2;
