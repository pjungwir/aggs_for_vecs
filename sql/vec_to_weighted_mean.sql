-- smallint weighted_mean lots
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint weighted_mean none
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id = -1;
-- smallint weighted_mean one null
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id = 1;
-- smallint weighted_mean array of nulls
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id = 2;
-- smallint weighted_mean one not-null
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id = 4;
-- smallint weighted_mean array of nulls and one other
SELECT vec_to_weighted_mean(smallints, smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int weighted_mean lots
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int weighted_mean none
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id = -1;
-- int weighted_mean one null
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id = 1;
-- int weighted_mean array of nulls
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id = 2;
-- int weighted_mean one not-null
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id = 4;
-- int weighted_mean array of nulls and one other
SELECT vec_to_weighted_mean(ints, ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint weighted_mean lots
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint weighted_mean none
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id = -1;
-- bigint weighted_mean one null
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id = 1;
-- bigint weighted_mean array of nulls
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id = 2;
-- bigint weighted_mean one not-null
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id = 4;
-- bigint weighted_mean array of nulls and one other
SELECT vec_to_weighted_mean(bigints, bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real weighted_mean lots
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real weighted_mean none
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id = -1;
-- real weighted_mean one null
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id = 1;
-- real weighted_mean array of nulls
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id = 2;
-- real weighted_mean one not-null
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id = 4;
-- real weighted_mean array of nulls and one other
SELECT vec_to_weighted_mean(reals, reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float weighted_mean lots
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float weighted_mean none
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id = -1;
-- float weighted_mean one null
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id = 1;
-- float weighted_mean array of nulls
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id = 2;
-- float weighted_mean one not-null
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id = 4;
-- float weighted_mean array of nulls and one other
SELECT vec_to_weighted_mean(floats, floats) FROM measurements WHERE sensor_id IN (2, 4);

-- numeric weighted mean lots
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- numeric weighted mean none
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id = -1;
-- numeric weighted mean one null
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id = 1;
-- numeric weighted mean array of nulls
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id = 2;
-- numeric weighted mean one not-null
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id = 4;
-- numeric weighted mean array of nulls and one other
SELECT vec_to_weighted_mean(nums, nums) FROM measurements WHERE sensor_id IN (2, 4);
-- numeric weighted mean everything
SELECT vec_to_weighted_mean(nums, nums) FROM measurements;
-- numeric weighted mean repeating tail
SELECT vec_to_weighted_mean(vals, vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[0]::numeric[]), (ARRAY[0]::numeric[])) t(vals);
-- numeric weighted mean whole number
SELECT vec_to_weighted_mean(vals, vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[1]::numeric[])) t(vals);
-- numeric weighted mean data 01
-- results expected to match:
-- WITH di AS (
--   SELECT idx_i, sum(val_i * val_i) / sum(val_i) AS avg_i
--   FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
--   GROUP BY idx_i
-- )
-- SELECT array_agg(avg_i ORDER BY idx_i) AS data_i_avg FROM di
SELECT vec_to_weighted_mean(data_i, data_i) FROM measurements2;
