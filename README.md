`aggs_for_vecs`
===============

This is a C-based Postgres extension
offering various aggregate functions like `min`, `max`, `avg`, and `var_samp`
that operate on **arrays** instead of scalars.
It treats each array as a "vector" and handles each element independently.
So suppose you have 3 rows each with a 4-element array like so:

| id |    vals    |
| -: | :--------- |
|  1 | {1,2,3,4}  |
|  2 | {5,0,-5,0} |
|  3 | {3,6,0,9}  |

Then `SELECT vec_to_min(vals)` will pick the minimum item in each array position,
giving you `{1,0,-5,0}`.

Note that the functions here are true [aggregate functions](https://www.postgresql.org/docs/current/static/functions-aggregate.html).
If you want something that provides aggregate-like behavior
by computing stats from a *single array*,
take a look at my other extension [`aggs_for_arrays`](https://github.com/pjungwir/aggs_for_arrays).
You could say that this extension follows a row-based format and the other a column-based.



Details
-------

Functions support arrays of any numeric type: `SMALLINT`, `INTEGER`, `BIGINT`, `REAL`, or `DOUBLE PRECISION` (aka `FLOAT`).
They either return an array of the same type (e.g. `vec_to_min`) or an array of `FLOAT` (e.g. `vec_to_mean`).

All input arrays must be the same length, or you get an error. The output array will have the same length as the inputs.

`NULL`s are ignored, and `NULL` elements are also skipped.
Basically you get the same result as if you could do `MIN` on the first elements,
then `MIN` on the second elements, etc.
If all your inputs are simply `NULL`, then you'll get a `NULL` in return.
But if the inputs are *arrays of `NULL`s*,
then you'll get an array of `NULL`s in return (of the same length).

Note that when input arrays have `NULL` in some positions but not others,
you still get correct results for things like mean.
That is, we keep a count for each position separately and divide by the appropriate amount.
    


Installing
----------

This package installs like any Postgres extension. First say:

    make && sudo make install

You will need to have `pg_config` in your path,
but normally that is already the case.
You can check with `which pg_config`.
(If you have multiple Postgresses installed,
[make sure that `pg_config` points to the right one](http://stackoverflow.com/questions/30143046/pg-config-shows-9-4-instead-of-9-3/43403193#43403193).)

Then in the database of your choice say:

    CREATE EXTENSION aggs_for_vecs;

You can also run tests and benchmarks yourself with `make test` and `make bench`, respectively,
but first you'll have to set up databases for those to use.
If you run the commands and they can't find a database,
they'll give you instructions how to make one.



Aggregate functions
-------------------

#### `vec_to_count(ANYARRAY) RETURNS BIGINT[]`

Returns the count of non-nulls in each array position.

#### `vec_to_sum(ANYARRAY) RETURNS ANYARRAY`

Returns the sum of non-nulls in each array position.

#### `vec_to_min(ANYARRAY) RETURNS ANYARRAY`

Returns the minimum in each array position.

#### `vec_to_max(ANYARRAY) RETURNS ANYARRAY`

Returns the maximum in each array position.

#### `vec_to_mean(ANYARRAY) RETURNS FLOAT[]`

Returns the average (mean) in each array position.

#### `vec_to_weighted_mean(ANYARRAY, ANYARRAY) RETURNS FLOAT[]`

Returns the weighted average (mean) in each array position,
using the first parameter for the values and the second for the weights.
The two arrays should have the same length.

#### `vec_to_var_samp(ANYARRAY) RETURNS FLOAT[]`

Returns the [sample variance](http://www.statisticshowto.com/how-to-find-the-sample-variance-and-standard-deviation-in-statistics/) in each array position.
The code is very similar to [the built-in `var_samp` function](https://www.postgresql.org/docs/current/static/functions-aggregate.html),
so if it works there it should work here (or it's a bug).

#### `hist_2d(x ANYELEMENT, y ANYELEMENT, x_bucket_start ANYELEMENT, y_bucket_start ANYELEMENT, x_bucket_width ANYELEMENT, y_bucket_width ANYELEMENT, x_bucket_count INTEGER, y_bucket_count INTEGER)`

Aggregate function that takes a bunch of `x` and `y` values, and plots them on a 2-D histogram. The other parameters determine the shape of the histogram (number of buckets on each axis, start of the buckets, width of each bucket).

#### `hist_md(vals ANYARRAY, indexes INTEGER[], bucket_starts ANYARRAY, bucket_widths ANYARRAY, bucket_counts INTEGER[])`

Aggregate function to compute an n-dimensional histogram. It takes a vector of values, and it uses `indexes` to pick one or more elements from that vector and treat them as `x`, `y`, `z`, etc. If you want 2 dimensions, there should be two values for `indexes`, two for `bucket_starts`, two for `bucket_widths`, and two for `bucket_counts`. Or if you want 3 dimensions, you need three values for each of those.

Since the values in `indexes` should follow Postgres's convention of 1-indexed arrays, so that if `indexes` is `{1,4}`, then we will use `vals[1]` and `vals[4]` as the histogram `x` and `y`.


Non-aggregate math functions
----------------------------

The following functions are not aggregate functions, and accept two arguments `(l, r)` in the
following forms:

1. array, array
2. array, number
3. number, array

If `number` is provided instead of `array`, it is treated as if it were an array of the same length as
the other argument, where every element has this value. In all cases the argument value types must be
the same (for example both the `integer` type), and when two arrays are provided they must be of the
same length. Each function returns an array of the same length as the input array(s) of the same type.

#### `vec_add(l, r) RETURNS ANYARRAY`

Returns each array position in the first argument added to the same position in the second argument.

#### `vec_div(l, r) RETURNS ANYARRAY`

Returns each array position in the first argument divided by the same position in the second argument.

#### `vec_mul(l, r) RETURNS ANYARRAY`

Returns each array position in the first argument multiplied by the same position in the second argument.

#### `vec_sub(l, r) RETURNS ANYARRAY`

Returns each array position in the second argument subtracted from the same position in the first argument.


Non-aggregate utility functions
-------------------------------

The following are other non-arrgregate functions that are useful in combination with the other functions
provided by this extension.

#### `pad_vec(ANYRARRAY, INTEGER) RETURNS ANYARRAY`

Return an array with the same elements as the given array, but extended to have the length of the second
argument if necessary. Any added elements will be set to `NULL`. If the given array is already the given
length, it is returned directly.

### `vec_coalesce(ANYARRAY, ANYELEMENT) RETURNS ANYARRAY`

Return an array with the same elements as the given array, execept all `NULL` elements are replaced
by the given second argument.

#### `vec_trim_scale(NUMERIC[]) RETURNS NUMERIC[]`

Trims trailing zeros from `NUMERIC` elements, for example on the results of a `vec_to_mean()` operation.
In Postgres 13 or later the built-in [`trim_scale` function](https://www.postgresql.org/docs/13/functions-math.html)
will be applied to each array element, which adjusts the scale of each numeric such that trailing zeros are
dropped. For Postgres 12 or older a polyfill implementation of that function is used.

#### `vec_without_outliers(ANYARRAY, ANYARRAY, ANYARRAY) RETURNS ANYARRAY`

Useful to trim down the inputs to the other functions here.
You pass it three arrays all of the same length and type.
The first array has the actual values.
The second array gives the minimum amount allowed in each position;
the third array, the maximum.
The function returns an array where each element is either the input value
(if within the min/max)
or `NULL` (if an outlier).
You can include `NULL`s in the min/max arrays to indicate an unbounded limit there,
or pass a simple `NULL` for either to indicate no bounds at all.


Testing
-------

These tests follow the [PGXS and `pg_regress` framework](https://www.postgresql.org/docs/current/extend-pgxs.html) used for Postgres extensions, including Postgres's own contrib package. To run the tests, first install the extension somewhere then say `make installcheck`. You can use standard libpq envvars to control the database connection, e.g. `PGPORT=5436 make installcheck`.



Limitations/TODO
----------------

- Lots of functions are still left to implement:

  - `vec_to_min_max`
  - `vec_to_median`
  - `vec_to_mode`
  - `vec_to_percentile`
  - `vec_to_percentiles`
  - `vec_to_skewness`
  - `vec_to_kurtosis`



Author
------

Paul A. Jungwirth




Benchmarks
----------

You can get the same behavior as this extension by using `UNNEST` to break up the input arrays,
and then `array_agg` to put the results back together.
But these benchmarks show that `aggs_for_vecs` functions are 9-10 times faster:

| function          |      SQL      | `aggs_for_vecs` |
|:------------------|--------------:|----------------:|
| `vec_to_min`      |    14150.7 ms |      1468.14 ms |
| `vec_to_max`      |    14062.4 ms |      1549.66 ms |
| `vec_to_mean`     |    14341.5 ms |      1586.62 ms |
| `vec_to_var_samp` |    14196.7 ms |      1578.92 ms |

