-- smallint sum lots
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint sum none
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint sum one null
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint sum array of nulls
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint sum one not-null
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint sum array of nulls and one other
SELECT vec_to_sum(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int sum lots
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int sum none
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id = -1;
-- int sum one null
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id = 1;
-- int sum array of nulls
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id = 2;
-- int sum one not-null
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id = 4;
-- int sum array of nulls and one other
SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint sum lots
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint sum none
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint sum one null
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint sum array of nulls
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint sum one not-null
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint sum array of nulls and one other
SELECT vec_to_sum(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real sum lots
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real sum none
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id = -1;
-- real sum one null
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id = 1;
-- real sum array of nulls
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id = 2;
-- real sum one not-null
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id = 4;
-- real sum array of nulls and one other
SELECT vec_to_sum(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 sum lots
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 sum none
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = -1;
-- float8 sum one null
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 1;
-- float8 sum array of nulls
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 2;
-- float8 sum one not-null
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 4;
-- float8 sum array of nulls and one other
SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id IN (2, 4);

-- numeric sum lots
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- numeric sum none
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = -1;
-- numeric sum one null
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 1;
-- numeric sum array of nulls
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 2;
-- numeric sum one not-null
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 4;
-- numeric sum array of nulls and one other
SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id IN (2, 4);
-- numeric sum data 01
-- results expected to match:
-- WITH di AS (
-- 	SELECT idx_i, sum(val_i) AS sum_i
-- 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
-- 	GROUP BY idx_i
-- )
-- SELECT array_agg(sum_i ORDER BY idx_i) AS data_i_sum FROM di
SELECT vec_to_sum(data_i) FROM measurements2;
