load test_helper

@test "float sub to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{4,NULL,3} | double precision[]" ]
}

@test "float sub to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{-4,NULL,-3} | double precision[]" ]
}

@test "float sub to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{0,NULL,0} | double precision[]" ]
}


@test "float sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float sub scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float sub scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float sub to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float sub to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "null float sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float sub to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "int sub to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{4,NULL,3} | integer[]" ]
}

@test "int sub to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{-4,NULL,-3} | integer[]" ]
}

@test "int sub to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{0,NULL,0} | integer[]" ]
}


@test "int sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int sub scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int sub scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int sub to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int sub to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "null int sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int sub to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "numeric sub to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{3.77,NULL,2.66} | numeric[]" ]
}

@test "numeric sub to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{-3.77,NULL,-2.66} | numeric[]" ]
}

@test "numeric sub to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{0.00,NULL,0.00} | numeric[]" ]
}


@test "numeric sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric sub scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric sub scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric sub to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric sub to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}


@test "null numeric sub to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric sub to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric sub to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_sub(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}
