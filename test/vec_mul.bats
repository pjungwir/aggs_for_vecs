load test_helper

@test "float mul to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,10} | double precision[]" ]
}

@test "float mul to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,10} | double precision[]" ]
}

@test "float mul to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,4} | double precision[]" ]
}


@test "float mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float mul scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float mul scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float mul to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float mul to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "null float mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float mul to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "int mul to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,10} | integer[]" ]
}

@test "int mul to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{5,NULL,10} | integer[]" ]
}

@test "int mul to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1,NULL,4} | integer[]" ]
}


@test "int mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int mul scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int mul scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int mul to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int mul to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "null int mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int mul to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "numeric mul to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6.15,NULL,11.70} | numeric[]" ]
}

@test "numeric mul to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6.15,NULL,11.70} | numeric[]" ]
}

@test "numeric mul to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{1.5129,NULL,5.4756} | numeric[]" ]
}


@test "numeric mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric mul scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric mul scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric mul to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric mul to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}


@test "null numeric mul to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric mul to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric mul to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_mul(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}
