
############################################################################
echo
echo "vec_to_mean_numeric"
echo "==================="
############################################################################

assign sql_rows <<EOQ
  WITH
  bounds AS (
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
            avg(n) AS mean_n
    FROM    bounds,
            measurements,
            UNNEST(nums) WITH ORDINALITY AS x(n, i)
    WHERE   sensor_id = 1
    AND     measured_at BETWEEN min_time AND max_time
    GROUP BY bucket, i
  )
  SELECT  bucket, array_agg(mean_n ORDER BY i) AS mean_ns
  FROM    unnested
  GROUP BY bucket
  ORDER BY bucket
  ;
EOQ

assign c_array <<EOQ
  WITH
  bounds AS (
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
          vec_to_mean(nums)
  FROM    bounds,
          measurements
  WHERE   sensor_id = 1
  AND     measured_at BETWEEN min_time AND max_time
  GROUP BY bucket
  ORDER BY bucket
  ;
EOQ

compare "$sql_rows" "$c_array"

