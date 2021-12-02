-- smallint hist_md
SELECT hist_md(smallints, '{1,2}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements;
-- smallint hist_md none
SELECT hist_md(smallints, '{1,2}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1;
-- smallint hist_md one null
SELECT hist_md(smallints, '{1,2}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1;
-- smallint hist_md array of nulls
SELECT hist_md(smallints, '{1,2}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2;
-- smallint hist_md one not-null
SELECT hist_md(smallints, '{1,3}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4;
-- smallint hist_md array of nulls and one other
SELECT hist_md(smallints, '{1,3}'::int[], '{0,0}'::smallint[], '{1,1}'::smallint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4);

-- int hist_md
SELECT hist_md(ints, '{1,2}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements;
-- int hist_md none
SELECT hist_md(ints, '{1,2}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1;
-- int hist_md one null
SELECT hist_md(ints, '{1,2}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1;
-- int hist_md array of nulls
SELECT hist_md(ints, '{1,2}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2;
-- int hist_md one not-null
SELECT hist_md(ints, '{1,3}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4;
-- int hist_md array of nulls and one other
SELECT hist_md(ints, '{1,3}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint hist_md
SELECT hist_md(bigints, '{1,2}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements;
-- bigint hist_md none
SELECT hist_md(bigints, '{1,2}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1;
-- bigint hist_md one null
SELECT hist_md(bigints, '{1,2}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1;
-- bigint hist_md array of nulls
SELECT hist_md(bigints, '{1,2}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2;
-- bigint hist_md one not-null
SELECT hist_md(bigints, '{1,3}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4;
-- bigint hist_md array of nulls and one other
SELECT hist_md(bigints, '{1,3}'::int[], '{0,0}'::bigint[], '{1,1}'::bigint[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4);

-- real hist_md
SELECT hist_md(reals, '{1,2}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements;
-- real hist_md none
SELECT hist_md(reals, '{1,2}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1;
-- real hist_md one null
SELECT hist_md(reals, '{1,2}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1;
-- real hist_md array of nulls
SELECT hist_md(reals, '{1,2}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2;
-- real hist_md one not-null
SELECT hist_md(reals, '{1,3}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4;
-- real hist_md array of nulls and one other
SELECT hist_md(reals, '{1,3}'::int[], '{0,0}'::real[], '{1,1}'::real[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 hist_md
SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements;
-- float8 hist_md none
SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1;
-- float8 hist_md one null
SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1;
-- float8 hist_md array of nulls
SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2;
-- float8 hist_md one not-null
SELECT hist_md(floats, '{1,3}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4;
-- float8 hist_md array of nulls and one other
SELECT hist_md(floats, '{1,3}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4);
