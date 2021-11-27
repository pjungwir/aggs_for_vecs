load test_helper

@test "int16 hist_2d" {
  result="$(query "SELECT hist_2d(ints[1], ints[2], 0, 0, 1, 1, 3, 3) FROM measurements")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,1,0},{0,2,0}}" ]
}

# @test "int32 hist_2d" {
  # result="$(query "SELECT hist_2d('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 hist_2d" {
  # result="$(query "SELECT hist_2d('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 hist_2d" {
  # result="$(query "SELECT hist_2d('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 hist_2d" {
  result="$(query "SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,1,0},{0,2,0}}" ]
}

@test "float8 hist_2d none" {
  result="$(query "SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 hist_2d one null" {
  result="$(query "SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,0,0}}" ]
}

@test "float8 hist_2d array of nulls" {
  result="$(query "SELECT hist_2d(floats[1], floats[2], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,0,0}}" ]
}

@test "float8 hist_2d one not-null" {
  result="$(query "SELECT hist_2d(floats[1], floats[3], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,1,0}}" ]
}

@test "float8 hist_2d array of nulls and one other" {
  result="$(query "SELECT hist_2d(floats[1], floats[3], 0::float, 0::float, 1::float, 1::float, 3, 3) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,1,0}}" ]
}
