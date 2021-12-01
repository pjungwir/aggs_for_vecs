load test_helper

@test "int16 outliers" {
  result="$(query "SELECT vec_without_outliers(ints, NULL, NULL) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
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

@test "float8 outliers both limits are null" {
  result="$(query "SELECT vec_without_outliers(floats, NULL, NULL) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "float8 outliers one limit is null" {
  result="$(query "SELECT vec_without_outliers(floats, NULL, ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,NULL}" ]
}

@test "float8 outliers both limits are present" {
  result="$(query "SELECT vec_without_outliers(floats, ARRAY[5, NULL, -5]::float[], ARRAY[NULL, NULL, 1]::float[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "float8 outliers pass mins and maxes" {
  result="$(query "SELECT vec_without_outliers(floats, ARRAY[-5, -5, -5]::float[], ARRAY[5, 5, 5]::float[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1,NULL,2}" ]
}

@test "numeric outliers both limits are null" {
  result="$(query "SELECT vec_without_outliers(nums, NULL, NULL) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric outliers one limit is null" {
  result="$(query "SELECT vec_without_outliers(nums, NULL, ARRAY[NULL, NULL, 1]::numeric[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,NULL}" ]
}

@test "numeric outliers both limits are present" {
  result="$(query "SELECT vec_without_outliers(nums, ARRAY[5, NULL, -5]::numeric[], ARRAY[NULL, NULL, 1]::numeric[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric outliers pass mins and maxes" {
  result="$(query "SELECT vec_without_outliers(nums, ARRAY[-5, -5, -5]::numeric[], ARRAY[5, 5, 5]::numeric[]) FROM measurements WHERE sensor_id IN (4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}
