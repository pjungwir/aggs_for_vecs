-- int pow to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int pow to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int pow to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- float pow to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float pow to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float pow to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- numeric pow to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric pow to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric pow to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric pow to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric pow to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
