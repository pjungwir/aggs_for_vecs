-- numeric stats
SELECT vec_agg_count(nums) AS counts
	, vec_agg_sum(nums) AS sums
	, vec_trim_scale(vec_agg_mean(nums)) AS means
	, vec_agg_min(nums) AS mins
	, vec_agg_max(nums) AS maxes
FROM measurements;

-- numeric stats 2
SELECT vec_agg_count(data_i) AS counts
	, vec_agg_sum(data_i) AS sums
	, vec_trim_scale(vec_agg_mean(data_i)) AS means
	, vec_agg_min(data_i) AS mins
	, vec_agg_max(data_i) AS maxes
FROM measurements2;