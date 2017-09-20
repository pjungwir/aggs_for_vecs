load test_helper

@test "int16 hist_md" {
  result="$(query "SELECT hist_md(ints, '{1,2}'::int[], '{0,0}'::int[], '{1,1}'::int[], '{3,3}'::int[]) FROM measurements")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,1,0},{0,2,0}}" ]
}

# @test "int32 hist_md" {
  # result="$(query "SELECT hist_md('{1,1,5,2,0}'::integer[])")";
  # [ "$result" = "0" ]
# }

# @test "int64 hist_md" {
  # result="$(query "SELECT hist_md('{1,1,5,2,0}'::bigint[])")";
  # [ "$result" = "0" ]
# }

# @test "float4 hist_md" {
  # result="$(query "SELECT hist_md('{1,1,5,2,0}'::real[])")";
  # [ "$result" = "0" ]
# }

@test "float8 hist_md" {
  result="$(query "SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,1,0},{0,2,0}}" ]
}

@test "float8 hist_md none" {
  result="$(query "SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = -1")";
  echo $result;
  [ "$result" = "NULL" ]
}

@test "float8 hist_md one null" {
  result="$(query "SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 1")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,0,0}}" ]
}

@test "float8 hist_md array of nulls" {
  result="$(query "SELECT hist_md(floats, '{1,2}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 2")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,0,0}}" ]
}

@test "float8 hist_md one not-null" {
  result="$(query "SELECT hist_md(floats, '{1,3}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id = 4")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,1,0}}" ]
}

@test "float8 hist_md array of nulls and one other" {
  result="$(query "SELECT hist_md(floats, '{1,3}'::int[], '{0,0}'::float[], '{1,1}'::float[], '{3,3}'::int[]) FROM measurements WHERE sensor_id IN (2, 4)")";
  echo $result;
  [ "$result" = "{{0,0,0},{0,0,0},{0,1,0}}" ]
}

@test "string hist_md" {
  run query "SELECT hist_md(vals, '{1,2}'::int[], '{a,a}'::text[], '{b,b}'::text[], '{3,3}'::int[]) FROM (VALUES (ARRAY['a', 'b']), (ARRAY['b', 'c'])) t(vals)"
  echo ${lines}
  [ "${lines[0]}" = "ERROR:  hist_md vals must be array of SMALLINT, INTEGER, BIGINT, REAL, or DOUBLE PRECISION" ]
}
