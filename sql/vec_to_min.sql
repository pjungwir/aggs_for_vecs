-- smallint min lots
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint min none
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint min one null
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint min array of nulls
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint min one not-null
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint min array of nulls and one other
SELECT vec_to_min(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int min lots
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int min none
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id = -1;
-- int min one null
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id = 1;
-- int min array of nulls
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id = 2;
-- int min one not-null
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id = 4;
-- int min array of nulls and one other
SELECT vec_to_min(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint min lots
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint min none
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint min one null
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint min array of nulls
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint min one not-null
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint min array of nulls and one other
SELECT vec_to_min(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real min lots
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real min none
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id = -1;
-- real min one null
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id = 1;
-- real min array of nulls
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id = 2;
-- real min one not-null
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id = 4;
-- real min array of nulls and one other
SELECT vec_to_min(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 min lots
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 min none
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = -1;
-- float8 min one null
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 1;
-- float8 min array of nulls
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 2;
-- float8 min one not-null
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 4;
-- float8 min array of nulls and one other
SELECT vec_to_min(floats) FROM measurements WHERE sensor_id IN (2, 4);
