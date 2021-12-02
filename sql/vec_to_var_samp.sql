-- smallint var_samp lots
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint var_samp none
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint var_samp one null
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint var_samp array of nulls
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint var_samp one not-null
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint var_samp array of nulls and one other
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int var_samp lots
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int var_samp none
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = -1;
-- int var_samp one null
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 1;
-- int var_samp array of nulls
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 2;
-- int var_samp one not-null
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 4;
-- int var_samp array of nulls and one other
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint var_samp lots
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint var_samp none
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint var_samp one null
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint var_samp array of nulls
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint var_samp one not-null
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint var_samp array of nulls and one other
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real var_samp lots
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real var_samp none
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = -1;
-- real var_samp one null
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 1;
-- real var_samp array of nulls
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 2;
-- real var_samp one not-null
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 4;
-- real var_samp array of nulls and one other
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 var_samp lots
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 var_samp none
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = -1;
-- float8 var_samp one null
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 1;
-- float8 var_samp array of nulls
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 2;
-- float8 var_samp one not-null
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 4;
-- float8 var_samp array of nulls and one other
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (2, 4);

-- numeric var_samp lots
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- numeric var_samp none
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = -1;
-- numeric var_samp one null
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 1;
-- numeric var_samp array of nulls
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 2;
-- numeric var_samp one not-null
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 4;
-- numeric var_samp array of nulls and one other
SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id IN (2, 4);
-- "numeric var_samp data 01 data_i" results calculated via:
-- WITH di AS (
-- 	SELECT idx_i, var_samp(val_i) AS var_samp_i
-- 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
-- 	GROUP BY idx_i
-- )
-- SELECT array_agg(var_samp_i ORDER BY idx_i) AS data_i_var_samp FROM di
--
-- Giving _very slightly_ different results from vec_to_var_samp; have not figured out why, but
-- assuming difference in scale handling for var_samp vs manual numeric calculations. Above gives:
-- {3010518348472.5286,45266160.727322130532,12.8248416278119149,0.13484388848692884296,1007125661019.31762295,0.00445150048159007602,49464.85046351161695,4016221414458.0807,3036555176748.7055}

-- numeric var_samp data 01 data_i
SELECT vec_to_var_samp(data_i) FROM measurements2;
-- "numeric var_samp data 01 data_a" results calculated via:
-- WITH da AS (
-- 	SELECT idx_a, var_samp(val_a) AS var_samp_a
-- 	FROM measurements2 d, unnest(d.data_a) WITH ORDINALITY AS a(val_a, idx_a)
-- 	GROUP BY idx_a
-- )
-- SELECT array_agg(var_samp_a ORDER BY idx_a) AS data_a_var_samp FROM da
--
-- Giving _very slightly_ different results from vec_to_var_samp; have not figured out why, but
-- assuming difference in scale handling for var_samp vs manual numeric calculations. Above gives:
-- {3111992499.95126515,NULL,0}

-- numeric var_samp data 01 data_a
SELECT vec_to_var_samp(pad_vec(data_a, 3)) FROM measurements2;
