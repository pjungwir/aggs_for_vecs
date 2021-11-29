load test_helper

@test "trim_scale all null" {
  result="$(query "SELECT vec_trim_scale(ARRAY[NULL, NULL, NULL]::numeric[])")";
  echo $result;
  [ "$result" = "{NULL,NULL,NULL}" ]
}

@test "trim_scale no trailing zeros" {
  result="$(query "SELECT vec_trim_scale(ARRAY['1','2.2','3.03']::numeric[])")";
  echo $result;
  [ "$result" = "{1,2.2,3.03}" ]
}

@test "trim_scale trailing zeros" {
  result="$(query "SELECT vec_trim_scale(ARRAY[100,2.00,3.45600,400.0040]::numeric[])")";
  echo $result;
  [ "$result" = "{100,2,3.456,400.004}" ]
}

@test "trim_scale mean lots" {
  result="$(query "SELECT vec_trim_scale(vec_to_mean(nums)) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1.23,2.34,2.895}" ]
}

# trim_scale from measurements2 query results calculated via:
# WITH da AS (
# 	SELECT idx_i, avg(val_a) AS avg_a
# 	FROM measurements2 d, unnest(d.data_a) WITH ORDINALITY AS a(val_a, idx_i)
# 	GROUP BY idx_i
# )
# SELECT array_agg(avg_a ORDER BY idx_i) AS data_a_avg FROM da
# 
# {6330897.179347826087,NULL,61.7650000000000000}

@test "trim_scale from measurements2 query" {
  result="$(query "SELECT vec_trim_scale(vec_to_mean(pad_vec(data_a,3))) FROM measurements2;")";
  echo $result;
  [ "$result" = "{6330897.179347826087,NULL,61.765}" ]
}
