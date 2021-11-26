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
