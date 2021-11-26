load test_helper

@test "int16 pad same length" {
  result="$(query "SELECT pad_vec(ints, 3) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "int16 pad adds NULLs" {
  result="$(query "SELECT pad_vec(ints, 5) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2,NULL,NULL}" ]
}

@test "int16 pad too long" {
  run query "SELECT pad_vec(ints, 2) FROM measurements WHERE sensor_id IN (4)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  pad_vec found an array with 3 elements but we're trying to pad out to only 2" ]
}

# @test "int32 count" {
  # result="$(query "SELECT vec_without_outliers('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 count" {
  # result="$(query "SELECT vec_without_outliers('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 count" {
  # result="$(query "SELECT vec_without_outliers('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 pad same length" {
  result="$(query "SELECT pad_vec(floats, 3) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 pad adds NULLs" {
  result="$(query "SELECT pad_vec(floats, 5) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2,NULL,NULL}" ]
}

@test "float8 pad too long" {
  run query "SELECT pad_vec(floats, 2) FROM measurements WHERE sensor_id IN (4)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  pad_vec found an array with 3 elements but we're trying to pad out to only 2" ]
}
