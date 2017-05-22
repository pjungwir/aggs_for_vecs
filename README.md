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
If you all inputs are simply `NULL`, then you'll get a `NULL` in return.
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



The functions
-------------

#### `vec_to_min(ANYARRAY) RETURNS ANYARRAY`

Returns the minimum in each array position.

#### `vec_to_max(ANYARRAY) RETURNS ANYARRAY`

Returns the maximum in each array position.

#### `vec_to_mean(ANYARRAY) RETURNS FLOAT[]`

Returns the average (mean) in each array position.

#### `vec_to_var_samp(ANYARRAY) RETURNS FLOAT[]`

Returns the [sample variance](http://www.statisticshowto.com/how-to-find-the-sample-variance-and-standard-deviation-in-statistics/) in each array position.
The code is very similar to [the built-in `var_samp` function](https://www.postgresql.org/docs/current/static/functions-aggregate.html),
so if it works there it should work here (or it's a bug).



Limitations/TODO
----------------

- Tests for floats are pretty good, but we need tests for the other numeric types.
- Lots of functions are still left to implement:

  - `vec_to_count`
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

