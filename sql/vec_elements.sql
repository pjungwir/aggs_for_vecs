-- vec_elements with null LHS
SELECT vec_elements(NULL::text[], '{1,2,3}'::int[]);

-- vec_elements with null RHS
SELECT vec_elements('{a,b,c}'::text[], NULL);

-- vec_elements with both null
SELECT vec_elements(NULL::text[], NULL);

-- vec_elements with negative index
SELECT vec_elements('{a,b,c}'::text[], '{-1,2,3}'::int[]);

-- vec_elements with zero index
SELECT vec_elements('{a,b,c}'::text[], '{0,2,3}'::int[]);

-- vec_elements with too-large index
SELECT vec_elements('{a,b,c}'::text[], '{1,2,4}'::int[]);

-- vec_elements with same index twice
SELECT vec_elements('{a,b,c}'::text[], '{1,2,2}'::int[]);

-- vec_elements with normal indexes
SELECT vec_elements('{a,b,c}'::text[], '{1,2,3}'::int[]);

-- vec_elements with normal indexes backwards
SELECT vec_elements('{a,b,c}'::text[], '{3,2,1}'::int[]);

-- vec_elements with empty array on LHS
SELECT vec_elements('{}'::text[], '{1,2,3}'::int[]);

-- vec_elements with empty array on RHS
SELECT vec_elements('{a,b,c}'::text[], '{}'::int[]);
