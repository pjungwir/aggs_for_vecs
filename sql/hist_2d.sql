-- smallint hist_2d
SELECT hist_2d(smallints[1], smallints[2], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements;
-- smallint hist_2d none
SELECT hist_2d(smallints[1], smallints[2], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements WHERE sensor_id = -1;
-- smallint hist_2d one null
SELECT hist_2d(smallints[1], smallints[2], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements WHERE sensor_id = 1;
-- smallint hist_2d array of nulls
SELECT hist_2d(smallints[1], smallints[2], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements WHERE sensor_id = 2;
-- smallint hist_2d one not-null
SELECT hist_2d(smallints[1], smallints[3], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements WHERE sensor_id = 4;
-- smallint hist_2d array of nulls and one other
SELECT hist_2d(smallints[1], smallints[3], 0::smallint, 0::smallint, 1::smallint, 1::smallint, 3, 3) FROM measurements WHERE sensor_id IN (2, 4);

-- int hist_2d
SELECT hist_2d(ints[1], ints[2], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements;
-- int hist_2d none
SELECT hist_2d(ints[1], ints[2], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements WHERE sensor_id = -1;
-- int hist_2d one null
SELECT hist_2d(ints[1], ints[2], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements WHERE sensor_id = 1;
-- int hist_2d array of nulls
SELECT hist_2d(ints[1], ints[2], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements WHERE sensor_id = 2;
-- int hist_2d one not-null
SELECT hist_2d(ints[1], ints[3], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements WHERE sensor_id = 4;
-- int hist_2d array of nulls and one other
SELECT hist_2d(ints[1], ints[3], 0::int, 0::int, 1::int, 1::int, 3, 3) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint hist_2d
SELECT hist_2d(bigints[1], bigints[2], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements;
-- bigint hist_2d none
SELECT hist_2d(bigints[1], bigints[2], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements WHERE sensor_id = -1;
-- bigint hist_2d one null
SELECT hist_2d(bigints[1], bigints[2], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements WHERE sensor_id = 1;
-- bigint hist_2d array of nulls
SELECT hist_2d(bigints[1], bigints[2], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements WHERE sensor_id = 2;
-- bigint hist_2d one not-null
SELECT hist_2d(bigints[1], bigints[3], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements WHERE sensor_id = 4;
-- bigint hist_2d array of nulls and one other
SELECT hist_2d(bigints[1], bigints[3], 0::bigint, 0::bigint, 1::bigint, 1::bigint, 3, 3) FROM measurements WHERE sensor_id IN (2, 4);

-- real hist_2d
SELECT hist_2d(reals[1], reals[2], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements;
-- real hist_2d none
SELECT hist_2d(reals[1], reals[2], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements WHERE sensor_id = -1;
-- real hist_2d one null
SELECT hist_2d(reals[1], reals[2], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements WHERE sensor_id = 1;
-- real hist_2d array of nulls
SELECT hist_2d(reals[1], reals[2], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements WHERE sensor_id = 2;
-- real hist_2d one not-null
SELECT hist_2d(reals[1], reals[3], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements WHERE sensor_id = 4;
-- real hist_2d array of nulls and one other
SELECT hist_2d(reals[1], reals[3], 0::real, 0::real, 1::real, 1::real, 3, 3) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 hist_2d
SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements;
-- float8 hist_2d none
SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = -1;
-- float8 hist_2d one null
SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 1;
-- float8 hist_2d array of nulls
SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 2;
-- float8 hist_2d one not-null
SELECT hist_2d(floats[1], floats[3], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 4;
-- float8 hist_2d array of nulls and one other
SELECT hist_2d(floats[1], floats[3], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id IN (2, 4);
