
############################################################################
echo
echo "vec_agg_stat"
echo "============"
############################################################################

assign sql_rows <<EOQ
  WITH bounds AS (
    SELECT  min(measured_at) AS min_time,
            max(measured_at) AS max_time
    FROM    measurements
    WHERE   sensor_id = 1
  ),
  unnested AS (
    SELECT  width_bucket(
              EXTRACT(epoch FROM measured_at),
              EXTRACT(epoch FROM min_time),
              EXTRACT(epoch FROM max_time),
              300
            ) AS bucket,
            i,
            count(n) AS cnt,
            min(n) AS min_n,
            max(n) AS max_n,
            avg(n) AS mean_n
    FROM    bounds,
            measurements,
            UNNEST(nums) WITH ORDINALITY AS x(n, i)
    WHERE   sensor_id = 1
    AND     measured_at BETWEEN min_time AND max_time
    GROUP BY bucket, i
  )
  SELECT  bucket,
          array_agg(cnt ORDER BY i) AS cnt_s,
          array_agg(min_n ORDER BY i) AS min_ns,
          array_agg(max_n ORDER BY i) AS max_ns,
          array_agg(mean_n ORDER BY i) AS mean_ns
  FROM    unnested
  GROUP BY bucket
  ORDER BY bucket
  ;
EOQ

assign c_array <<EOQ
  WITH bounds AS (
    SELECT  min(measured_at) AS min_time,
            max(measured_at) AS max_time
    FROM    measurements
    WHERE   sensor_id = 1
  )
  SELECT  width_bucket(
              EXTRACT(epoch FROM measured_at),
              EXTRACT(epoch FROM min_time),
              EXTRACT(epoch FROM max_time),
              300
          ) AS bucket,
          vec_agg_count(vec_stat_agg(nums)),
          vec_agg_min(vec_stat_agg(nums)),
          vec_agg_max(vec_stat_agg(nums)),
          vec_agg_mean(vec_stat_agg(nums))
  FROM    bounds,
          measurements
  WHERE   sensor_id = 1
  AND     measured_at BETWEEN min_time AND max_time
  GROUP BY bucket
  ORDER BY bucket
  ;
EOQ

compare "$sql_rows" "$c_array"
