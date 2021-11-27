load test_helper

@test "int16 var_samp" {
  result="$(query "SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{0,NULL,0.5}" ]
}

# @test "int32 var_samp" {
  # result="$(query "SELECT vec_to_var_samp('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 var_samp" {
  # result="$(query "SELECT vec_to_var_samp('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 var_samp" {
  # result="$(query "SELECT vec_to_var_samp('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 var_samp lots" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{0,NULL,0.5}" ]
}

@test "float8 var_samp none" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 var_samp one null" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 var_samp array of nulls" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 var_samp one not-null" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 var_samp array of nulls and one other" {
  result="$(query "SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}
