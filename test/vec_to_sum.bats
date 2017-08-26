load test_helper

@test "int16 sum" {
  result="$(query "SELECT vec_to_sum(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2,2,5}" ]
}

# @test "int32 sum" {
  # result="$(query "SELECT vec_to_sum('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 sum" {
  # result="$(query "SELECT vec_to_sum('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 sum" {
  # result="$(query "SELECT vec_to_sum('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 sum lots" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2,2,5}" ]
}

@test "float8 sum none" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 sum one null" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 sum array of nulls" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 sum one not-null" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 sum array of nulls and one other" {
  result="$(query "SELECT vec_to_sum(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "string sum" {
  run query "SELECT vec_to_sum(vals) FROM (VALUES (ARRAY['a']), (ARRAY['b'])) t(vals)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  vec_to_sum input must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION" ]
}
