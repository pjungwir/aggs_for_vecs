-- int add to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int add to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int add to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- float add to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float add to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float add to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- numeric add to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric add to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric add to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric add to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric add to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
