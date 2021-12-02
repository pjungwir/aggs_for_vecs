-- int sub to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int sub to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int sub to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- float sub to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float sub to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float sub to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- numeric sub to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric sub to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric sub to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric sub to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric sub to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
