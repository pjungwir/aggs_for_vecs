-- int mul to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int mul to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int mul to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- float mul to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float mul to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float mul to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- numeric mul to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric mul to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric mul to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric mul to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric mul to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
