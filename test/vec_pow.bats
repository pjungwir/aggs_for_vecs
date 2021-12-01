load test_helper

@test "float pow to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,25} | double precision[]" ]
}

@test "float pow to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,32} | double precision[]" ]
}

@test "float pow to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,4} | double precision[]" ]
}


@test "float pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float pow scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float pow scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float pow to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float pow to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "null float pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float pow to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "int pow to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,25} | integer[]" ]
}

@test "int pow to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,32} | integer[]" ]
}

@test "int pow to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,4} | integer[]" ]
}


@test "int pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int pow scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int pow scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int pow to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int pow to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "null int pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int pow to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "numeric pow to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{7.2399089640616945,NULL,43.210551585736423} | numeric[]" ]
}

@test "numeric pow to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{2.8153056843000000,NULL,70.1583371424000000} | numeric[]" ]
}

@test "numeric pow to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1.2899809210012809,NULL,7.3108034201885126} | numeric[]" ]
}


@test "numeric pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric pow scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric pow scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric pow to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric pow to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}


@test "null numeric pow to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric pow to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric pow to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_pow(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}
