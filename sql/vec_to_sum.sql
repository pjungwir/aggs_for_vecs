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
