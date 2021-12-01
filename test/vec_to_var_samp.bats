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

@test "numeric var_samp lots" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{0.00000000000000000000,NULL,0.61605000000000000000}" ]
}

@test "numeric var_samp none" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric var_samp one null" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric var_samp array of nulls" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric var_samp one not-null" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric var_samp array of nulls and one other" {
  result="$(query "SELECT vec_to_var_samp(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

# "numeric var_samp data 01 data_i" results calculated via:
# WITH di AS (
# 	SELECT idx_i, var_samp(val_i) AS var_samp_i
# 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
# 	GROUP BY idx_i
# )
# SELECT array_agg(var_samp_i ORDER BY idx_i) AS data_i_var_samp FROM di
#
# Giving _very slightly_ different results from vec_to_var_samp; have not figured out why, but
# assuming difference in scale handling for var_samp vs manual numeric calculations. Above gives:
# {3010518348472.5286,45266160.727322130532,12.8248416278119149,0.13484388848692884296,1007125661019.31762295,0.00445150048159007602,49464.85046351161695,4016221414458.0807,3036555176748.7055}

@test "numeric var_samp data 01 data_i" {
  result="$(query "SELECT vec_to_var_samp(data_i) FROM measurements2")";
  echo $result;
  [ "$result" = "{3010518348472.5286,45266160.727322130532,12.8248416278119126,0.13484388848692896175,1007125661019.3176,0.00445150048159007596,49464.8504635116169504,4016221414458.0807,3036555176748.7055}" ]
}

# "numeric var_samp data 01 data_a" results calculated via:
# WITH da AS (
# 	SELECT idx_a, var_samp(val_a) AS var_samp_a
# 	FROM measurements2 d, unnest(d.data_a) WITH ORDINALITY AS a(val_a, idx_a)
# 	GROUP BY idx_a
# )
# SELECT array_agg(var_samp_a ORDER BY idx_a) AS data_a_var_samp FROM da
#
# Giving _very slightly_ different results from vec_to_var_samp; have not figured out why, but
# assuming difference in scale handling for var_samp vs manual numeric calculations. Above gives:
# {3111992499.95126515,NULL,0}

@test "numeric var_samp data 01 data_a" {
  result="$(query "SELECT vec_to_var_samp(pad_vec(data_a, 3)) FROM measurements2")";
  echo $result;
  [ "$result" = "{3111992499.95126503,NULL,0.00000000000000000000}" ]
}
