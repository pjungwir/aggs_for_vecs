load test_helper

@test "int16 max" {
  result="$(query "SELECT vec_to_max(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,3}" ]
}

# @test "int32 max" {
  # result="$(query "SELECT vec_to_max('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 max" {
  # result="$(query "SELECT vec_to_max('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 max" {
  # result="$(query "SELECT vec_to_max('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 max lots" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1,2,3}" ]
}

@test "float8 max none" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 max one null" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 max array of nulls" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 max one not-null" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 max array of nulls and one other" {
  result="$(query "SELECT vec_to_max(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}
