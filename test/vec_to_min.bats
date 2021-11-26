load test_helper

@test "int16 min" {
  result="$(query "SELECT vec_to_min(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,2}" ]
}

# @test "int32 min" {
  # result="$(query "SELECT vec_to_min('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 min" {
  # result="$(query "SELECT vec_to_min('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 min" {
  # result="$(query "SELECT vec_to_min('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 min lots" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,2}" ]
}

@test "float8 min none" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 min one null" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 min array of nulls" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 min one not-null" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 min array of nulls and one other" {
  result="$(query "SELECT vec_to_min(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "string min" {
  run query "SELECT vec_to_min(vals) FROM (VALUES (ARRAY['a']), (ARRAY['b'])) t(vals)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  vec_to_min input must be array of SMALLINT, INTEGER, BIGINT, REAL, DOUBLE PRECISION, or NUMERIC" ]
}

@test "numeric min lots" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1.23,2.34,2.34}" ]
}

@test "numeric min none" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric min one null" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric min array of nulls" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric min one not-null" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric min array of nulls and one other" {
  result="$(query "SELECT vec_to_min(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}