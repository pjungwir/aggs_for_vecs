-- smallint count lots
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint count none
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint count one null
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint count array of nulls
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint count one not-null
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint count array of nulls and one other
SELECT vec_to_count(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int count lots
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int count none
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id = -1;
-- int count one null
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id = 1;
-- int count array of nulls
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id = 2;
-- int count one not-null
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id = 4;
-- int count array of nulls and one other
SELECT vec_to_count(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint count lots
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint count none
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint count one null
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint count array of nulls
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint count one not-null
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint count array of nulls and one other
SELECT vec_to_count(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real count lots
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real count none
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id = -1;
-- real count one null
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id = 1;
-- real count array of nulls
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id = 2;
-- real count one not-null
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id = 4;
-- real count array of nulls and one other
SELECT vec_to_count(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 count lots
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 count none
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = -1;
-- float8 count one null
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 1;
-- float8 count array of nulls
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 2;
-- float8 count one not-null
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 4;
-- float8 count array of nulls and one other
SELECT vec_to_count(floats) FROM measurements WHERE sensor_id IN (2, 4);

-- numeric count lots
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- numeric count none
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = -1;
-- numeric count one null
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 1;
-- numeric count array of nulls
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 2;
-- numeric count one not-null
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 4;
-- numeric count array of nulls and one other
SELECT vec_to_count(nums) FROM measurements WHERE sensor_id IN (2, 4);
