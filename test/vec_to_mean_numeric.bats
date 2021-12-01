load test_helper

@test "numeric mean lots" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1.23000000000000000000,2.3400000000000000,2.8950000000000000}" ]
}

@test "numeric mean none" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric mean one null" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "numeric mean array of nulls" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "numeric mean one not-null" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{1.23000000000000000000,NULL,2.3400000000000000}" ]
}

@test "numeric mean array of nulls and one other" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1.23000000000000000000,NULL,2.3400000000000000}" ]
}

@test "numeric mean everything" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements")";
  echo $result;
  [ "$result" = "{1.23000000000000000000,1.9700000000000000,3.7000000000000000}" ]
}

@test "numeric mean repeating tail" {
  result="$(query "SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[0]::numeric[]), (ARRAY[0]::numeric[])) t(vals)")";
  echo $result;
  [ "$result" = "{0.33333333333333333333}" ]
}

@test "numeric mean whole number" {
  result="$(query "SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[1]::numeric[])) t(vals)")";
  echo $result;
  [ "$result" = "{1.00000000000000000000}" ]
}

# numeric mean data 01 results calculated via:
# WITH di AS (
# 	SELECT idx_i, avg(val_i) AS avg_i
# 	FROM measurements2 d, unnest(d.data_i) WITH ORDINALITY AS a(val_i, idx_i)
# 	GROUP BY idx_i
# )
# SELECT array_agg(avg_i ORDER BY idx_i) AS data_i_avg FROM di

@test "numeric mean data 01" {
  result="$(query "SELECT vec_to_mean(data_i) FROM measurements2")";
  echo $result;
  [ "$result" = "{195478.788043478261,18.8083637445652174,229.7496696739130435,49.9944814891304348,137826.625000000000,0.99496976375000000000,-5.2822864641304348,254911.581521739130,136650.663043478261}" ]
}
