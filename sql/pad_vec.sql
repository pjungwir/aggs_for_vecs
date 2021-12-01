-- smallint pad same length
SELECT pad_vec(smallints, 3) FROM measurements WHERE sensor_id IN (4);
-- smallint pad adds NULLs
SELECT pad_vec(smallints, 5) FROM measurements WHERE sensor_id IN (4);
-- smallint pad too long
SELECT pad_vec(smallints, 2) FROM measurements WHERE sensor_id IN (4);

-- int pad same length
SELECT pad_vec(ints, 3) FROM measurements WHERE sensor_id IN (4);
-- int pad adds NULLs
SELECT pad_vec(ints, 5) FROM measurements WHERE sensor_id IN (4);
-- int pad too long
SELECT pad_vec(ints, 2) FROM measurements WHERE sensor_id IN (4);

-- bigint pad same length
SELECT pad_vec(bigints, 3) FROM measurements WHERE sensor_id IN (4);
-- bigint pad adds NULLs
SELECT pad_vec(bigints, 5) FROM measurements WHERE sensor_id IN (4);
-- bigint pad too long
SELECT pad_vec(bigints, 2) FROM measurements WHERE sensor_id IN (4);

-- real pad same length
SELECT pad_vec(reals, 3) FROM measurements WHERE sensor_id IN (4);
-- real pad adds NULLs
SELECT pad_vec(reals, 5) FROM measurements WHERE sensor_id IN (4);
-- real pad too long
SELECT pad_vec(reals, 2) FROM measurements WHERE sensor_id IN (4);

-- float8 pad same length
SELECT pad_vec(floats, 3) FROM measurements WHERE sensor_id IN (4);
-- float8 pad adds NULLs
SELECT pad_vec(floats, 5) FROM measurements WHERE sensor_id IN (4);
-- float8 pad too long
SELECT pad_vec(floats, 2) FROM measurements WHERE sensor_id IN (4);

-- numeric pad same length
SELECT pad_vec(nums, 3) FROM measurements WHERE sensor_id IN (4);
-- numeric pad adds NULLs
SELECT pad_vec(nums, 5) FROM measurements WHERE sensor_id IN (4);
-- numeric pad too long
SELECT pad_vec(nums, 2) FROM measurements WHERE sensor_id IN (4);
