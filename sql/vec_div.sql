-- int div to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div to array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r);

-- int div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- int div to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null int div to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- float div to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- float div to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null float div to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r);

-- numeric div to scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div scalar to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div scalar to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to null array lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to null array rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric div to null scalar lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric div to null scalar rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- null numeric div to null array
SELECT r, pg_typeof(r) FROM (SELECT vec_div(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to scalar 0 lhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(0::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to scalar 0 rhs
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, 0::numeric) FROM measurements WHERE sensor_id IN (4)) r(r);
-- numeric div to array 0
SELECT r, pg_typeof(r) FROM (SELECT vec_div(nums, ARRAY[0,0,1]::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r);
