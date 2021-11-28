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

@test "numeric max lots" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1.23,2.34,3.45}" ]
}

@test "numeric max none" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric max one null" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric max array of nulls" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric max one not-null" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric max array of nulls and one other" {
  result="$(query "SELECT vec_to_max(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

# numeric max data 01 results calculated via:
# WITH di AS (
# 	SELECT idx_i, avg(val_i) AS avg_i
# 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
# 	GROUP BY idx_i
# )
# SELECT array_agg(avg_i ORDER BY idx_i) AS data_i_avg FROM di

@test "numeric max data 01" {
  result="$(query "SELECT vec_to_max(data_i) FROM measurements2")";
  echo $result;
  [ "$result" = "{23200619,48587.514387,234.99962,50.5,13161880,1,332.20728,23730754,23623545}" ]
}
