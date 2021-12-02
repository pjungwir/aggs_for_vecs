-- smallint mean lots
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint mean none
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint mean one null
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint mean array of nulls
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint mean one not-null
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint mean array of nulls and one other
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int mean lots
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int mean none
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = -1;
-- int mean one null
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 1;
-- int mean array of nulls
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 2;
-- int mean one not-null
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 4;
-- int mean array of nulls and one other
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint mean lots
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint mean none
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint mean one null
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint mean array of nulls
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint mean one not-null
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint mean array of nulls and one other
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real mean lots
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real mean none
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = -1;
-- real mean one null
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 1;
-- real mean array of nulls
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 2;
-- real mean one not-null
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 4;
-- real mean array of nulls and one other
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 mean lots
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 mean none
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = -1;
-- float8 mean one null
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 1;
-- float8 mean array of nulls
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 2;
-- float8 mean one not-null
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 4;
-- float8 mean array of nulls and one other
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (2, 4);

-- numeric mean lots
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- numeric mean none
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = -1;
-- numeric mean one null
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 1;
-- numeric mean array of nulls
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 2;
-- numeric mean one not-null
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 4;
-- numeric mean array of nulls and one other
SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (2, 4);
-- numeric mean everything
SELECT vec_to_mean(nums) FROM measurements;
-- numeric mean repeating tail
SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[0]::numeric[]), (ARRAY[0]::numeric[])) t(vals);
-- numeric mean whole number
SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[1]::numeric[])) t(vals);
-- numeric mean data 01
-- results expected to match:
-- WITH di AS (
--   SELECT idx_i, avg(val_i) AS avg_i
--   FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
--   GROUP BY idx_i
-- )
-- SELECT array_agg(avg_i ORDER BY idx_i) AS data_i_avg FROM di
SELECT vec_to_mean(data_i) FROM measurements2;
