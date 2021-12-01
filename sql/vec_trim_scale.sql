-- trim_scale all null
SELECT vec_trim_scale(ARRAY[NULL, NULL, NULL]::numeric[]);
-- trim_scale no trailing zeros
SELECT vec_trim_scale(ARRAY['1','2.2','3.03']::numeric[]);
-- trim_scale trailing zeros
SELECT vec_trim_scale(ARRAY[100,2.00,3.45600,400.0040]::numeric[]);
-- trim_scale mean lots
SELECT vec_trim_scale(vec_to_mean(nums)) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- trim_scale from measurements2 query
-- results expected to match:
-- WITH da AS (
--      SELECT idx_i, avg(val_a) AS avg_a
--      FROM measurements2 d, unnest(d.data_a) WITH ORDINALITY AS a(val_a, idx_i)
--      GROUP BY idx_i
-- )
-- SELECT array_agg(avg_a ORDER BY idx_i) AS data_a_avg FROM da
-- 
-- {6330897.179347826087,NULL,61.7650000000000000}
SELECT vec_trim_scale(vec_to_mean(pad_vec(data_a,3))) FROM measurements2;
