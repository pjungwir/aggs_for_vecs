-- smallint max lots
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint max none
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint max one null
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint max array of nulls
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint max one not-null
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint max array of nulls and one other
SELECT vec_to_max(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int max lots
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int max none
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id = -1;
-- int max one null
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id = 1;
-- int max array of nulls
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id = 2;
-- int max one not-null
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id = 4;
-- int max array of nulls and one other
SELECT vec_to_max(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint max lots
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint max none
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint max one null
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint max array of nulls
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint max one not-null
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint max array of nulls and one other
SELECT vec_to_max(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real max lots
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real max none
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id = -1;
-- real max one null
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id = 1;
-- real max array of nulls
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id = 2;
-- real max one not-null
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id = 4;
-- real max array of nulls and one other
SELECT vec_to_max(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 max lots
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 max none
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = -1;
-- float8 max one null
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 1;
-- float8 max array of nulls
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 2;
-- float8 max one not-null
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 4;
-- float8 max array of nulls and one other
SELECT vec_to_max(floats) FROM measurements WHERE sensor_id IN (2, 4);

