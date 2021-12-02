load test_helper

@test "float add to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6,NULL,7} | double precision[]" ]
}

@test "float add to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6,NULL,7} | double precision[]" ]
}

@test "float add to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{2,NULL,4} | double precision[]" ]
}


@test "float add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float, floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | double precision[]" ]
}

@test "float add scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float add scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], 5::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float add to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(floats, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "float add to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], floats) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "null float add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float, NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], NULL::float) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}

@test "null float add to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::float[], NULL::float[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | double precision[]" ]
}


@test "int add to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6,NULL,7} | integer[]" ]
}

@test "int add to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6,NULL,7} | integer[]" ]
}

@test "int add to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{2,NULL,4} | integer[]" ]
}


@test "int add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int, ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | integer[]" ]
}

@test "int add scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int add scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], 5::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int add to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(ints, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "int add to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], ints) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "null int add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int, NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], NULL::int) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}

@test "null int add to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::int[], NULL::int[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | integer[]" ]
}


@test "numeric add to scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6.23,NULL,7.34} | numeric[]" ]
}

@test "numeric add to scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{6.23,NULL,7.34} | numeric[]" ]
}

@test "numeric add to array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{2.46,NULL,4.68} | numeric[]" ]
}


@test "numeric add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric, nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL} | numeric[]" ]
}

@test "numeric add scalar to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(5::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric add scalar to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], 5::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric add to null array lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(nums, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "numeric add to null array rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], nums) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}


@test "null numeric add to null scalar lhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric, NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric add to null scalar rhs" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], NULL::numeric) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}

@test "null numeric add to null array" {
  result="$(query "SELECT r, pg_typeof(r) FROM (SELECT vec_add(NULL::numeric[], NULL::numeric[]) FROM measurements WHERE sensor_id IN (4)) r(r)")";
  echo $result;
  [ "$result" = "NULL | numeric[]" ]
}
