load test_helper

@test "int16 mean" {
  result="$(query "SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,2.5}" ]
}

# @test "int32 mean" {
  # result="$(query "SELECT vec_to_mean('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 mean" {
  # result="$(query "SELECT vec_to_mean('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 mean" {
  # result="$(query "SELECT vec_to_mean('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 mean lots" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,2.5}" ]
}

@test "float8 mean none" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 mean one null" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 mean array of nulls" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 mean one not-null" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 mean array of nulls and one other" {
  result="$(query "SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}
