load test_helper

@test "int16 count" {
  result="$(query "SELECT vec_to_count(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2,1,2}" ]
}

# @test "int32 count" {
  # result="$(query "SELECT vec_to_count('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 count" {
  # result="$(query "SELECT vec_to_count('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 count" {
  # result="$(query "SELECT vec_to_count('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 count lots" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2,1,2}" ]
}

@test "float8 count none" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 count one null" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 count array of nulls" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{0,0,0}" ]
}

@test "float8 count one not-null" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,0,1}" ]
}

@test "float8 count array of nulls and one other" {
  result="$(query "SELECT vec_to_count(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,0,1}" ]
}

@test "string count" {
  run query "SELECT vec_to_count(vals) FROM (VALUES (ARRAY['a']), (ARRAY['b'])) t(vals)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  vec_to_count input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC" ]
}

@test "numeric count lots" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2,1,2}" ]
}

@test "numeric count none" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric count one null" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric count array of nulls" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{0,0,0}" ]
}

@test "numeric count one not-null" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,0,1}" ]
}

@test "numeric count array of nulls and one other" {
  result="$(query "SELECT vec_to_count(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,0,1}" ]
}