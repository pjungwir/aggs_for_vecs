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

@test "numeric sum lots" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{2.46,2.34,5.79}" ]
}

@test "numeric sum none" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric sum one null" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric sum array of nulls" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric sum one not-null" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric sum array of nulls and one other" {
  result="$(query "SELECT vec_to_sum(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

# numeric sum data 01 results calculated via:
# WITH di AS (
# 	SELECT idx_i, sum(val_i) AS sum_i
# 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
# 	GROUP BY idx_i
# )
# SELECT array_agg(sum_i ORDER BY idx_i) AS data_i_sum FROM di

@test "numeric sum data 01" {
  result="$(query "SELECT vec_to_sum(data_i) FROM measurements2")";
  echo $result;
  [ "$result" = "{35968097,3460.738929,42273.93922,9198.984594,25360099,183.07443653,-971.9407094,46903731,25143722}" ]
}
