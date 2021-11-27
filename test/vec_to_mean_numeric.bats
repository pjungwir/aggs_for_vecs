load test_helper

@test "numeric mean lots" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (1, 2, 3, 4)")";
  echo $result;
  [ "$result" = "{1.23,2.34,2.895}" ]
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
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric mean array of nulls and one other" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{1.23,NULL,2.34}" ]
}

@test "numeric mean everything" {
  result="$(query "SELECT vec_to_mean(nums) FROM measurements")";
  echo $result;
  [ "$result" = "{1.23,1.97,3.7}" ]
}

@test "numeric mean repeating tail" {
  result="$(query "SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[0]::numeric[]), (ARRAY[0]::numeric[])) t(vals)")";
  echo $result;
  [ "$result" = "{0.33333333333333333333}" ]
}

@test "numeric mean whole number" {
  result="$(query "SELECT vec_to_mean(vals) FROM (VALUES (ARRAY[1]::numeric[]), (ARRAY[1]::numeric[])) t(vals)")";
  echo $result;
  [ "$result" = "{1}" ]
}
