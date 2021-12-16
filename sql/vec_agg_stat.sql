-- int2 stats
SELECT vec_agg_count(smallints) AS counts
	, vec_agg_sum(smallints) AS sums
	, vec_agg_mean(smallints) AS means
	, vec_agg_min(smallints) AS mins
	, vec_agg_max(smallints) AS maxes
FROM measurements;

-- int4 stats
SELECT vec_agg_count(ints) AS counts
	, vec_agg_sum(ints) AS sums
	, vec_agg_mean(ints) AS means
	, vec_agg_min(ints) AS mins
	, vec_agg_max(ints) AS maxes
FROM measurements;

-- int8 stats
SELECT vec_agg_count(bigints) AS counts
	, vec_agg_sum(bigints) AS sums
	, vec_agg_mean(bigints) AS means
	, vec_agg_min(bigints) AS mins
	, vec_agg_max(bigints) AS maxes
FROM measurements;

-- float4 stats
SELECT vec_agg_count(reals) AS counts
	, vec_agg_sum(reals) AS sums
	, vec_agg_mean(reals) AS means
	, vec_agg_min(reals) AS mins
	, vec_agg_max(reals) AS maxes
FROM measurements;

-- float8 stats
SELECT vec_agg_count(floats) AS counts
	, vec_agg_sum(floats) AS sums
	, vec_agg_mean(floats) AS means
	, vec_agg_min(floats) AS mins
	, vec_agg_max(floats) AS maxes
FROM measurements;

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

-- numeric stats 3
SELECT vec_agg_count(pad_vec(data_a, 3)) AS counts
	, vec_agg_sum(pad_vec(data_a, 3)) AS sums
	, vec_trim_scale(vec_agg_mean(pad_vec(data_a, 3))) AS means
	, vec_agg_min(pad_vec(data_a, 3)) AS mins
	, vec_agg_max(pad_vec(data_a, 3)) AS maxes
FROM measurements2;
