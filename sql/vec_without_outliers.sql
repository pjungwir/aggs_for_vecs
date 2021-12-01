-- smallint outliers both limits are null
SELECT vec_without_outliers(smallints, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- smallint outliers one limit is null
SELECT vec_without_outliers(smallints, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- smallint outliers both limits are present
SELECT vec_without_outliers(smallints, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- smallint outliers pass mins and maxes
SELECT vec_without_outliers(smallints, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4);

-- int outliers both limits are null
SELECT vec_without_outliers(ints, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- int outliers one limit is null
SELECT vec_without_outliers(ints, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- int outliers both limits are present
SELECT vec_without_outliers(ints, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- int outliers pass mins and maxes
SELECT vec_without_outliers(ints, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4);

-- bigint outliers both limits are null
SELECT vec_without_outliers(bigints, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- bigint outliers one limit is null
SELECT vec_without_outliers(bigints, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- bigint outliers both limits are present
SELECT vec_without_outliers(bigints, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- bigint outliers pass mins and maxes
SELECT vec_without_outliers(bigints, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4);

-- real outliers both limits are null
SELECT vec_without_outliers(reals, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- real outliers one limit is null
SELECT vec_without_outliers(reals, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- real outliers both limits are present
SELECT vec_without_outliers(reals, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- real outliers pass mins and maxes
SELECT vec_without_outliers(reals, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4);

-- float8 outliers both limits are null
SELECT vec_without_outliers(floats, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- float8 outliers one limit is null
SELECT vec_without_outliers(floats, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- float8 outliers both limits are present
SELECT vec_without_outliers(floats, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4);
-- float8 outliers pass mins and maxes
SELECT vec_without_outliers(floats, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4);

-- numeric outliers both limits are null
SELECT vec_without_outliers(nums, NULL, NULL) FROM measurements WHERE sensor_id IN (4);
-- numeric outliers one limit is null
SELECT vec_without_outliers(nums, NULL, ARRAY[NULL, NULL, 1]::numeric[]) FROM measurements WHERE sensor_id IN (4);
-- numeric outliers both limits are present
SELECT vec_without_outliers(nums, ARRAY[5, NULL, -5]::numeric[], ARRAY[NULL, NULL, 1]::numeric[]) FROM measurements WHERE sensor_id IN (4);
-- numeric outliers pass mins and maxes
SELECT vec_without_outliers(nums, ARRAY[-5, -5, -5]::numeric[], ARRAY[5, 5, 5]::numeric[]) FROM measurements WHERE sensor_id IN (4);
