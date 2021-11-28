-- smallint var_samp lots" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint var_samp none" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint var_samp one null" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint var_samp array of nulls" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint var_samp one not-null" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint var_samp array of nulls and one other" {
SELECT vec_to_var_samp(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int var_samp lots" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int var_samp none" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = -1;
-- int var_samp one null" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 1;
-- int var_samp array of nulls" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 2;
-- int var_samp one not-null" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id = 4;
-- int var_samp array of nulls and one other" {
SELECT vec_to_var_samp(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint var_samp lots" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint var_samp none" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint var_samp one null" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint var_samp array of nulls" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint var_samp one not-null" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint var_samp array of nulls and one other" {
SELECT vec_to_var_samp(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real var_samp lots" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real var_samp none" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = -1;
-- real var_samp one null" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 1;
-- real var_samp array of nulls" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 2;
-- real var_samp one not-null" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id = 4;
-- real var_samp array of nulls and one other" {
SELECT vec_to_var_samp(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 var_samp lots" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 var_samp none" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = -1;
-- float8 var_samp one null" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 1;
-- float8 var_samp array of nulls" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 2;
-- float8 var_samp one not-null" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id = 4;
-- float8 var_samp array of nulls and one other" {
SELECT vec_to_var_samp(floats) FROM measurements WHERE sensor_id IN (2, 4);
