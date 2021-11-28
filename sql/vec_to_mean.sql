-- smallint mean lots" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- smallint mean none" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = -1;
-- smallint mean one null" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 1;
-- smallint mean array of nulls" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 2;
-- smallint mean one not-null" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id = 4;
-- smallint mean array of nulls and one other" {
SELECT vec_to_mean(smallints) FROM measurements WHERE sensor_id IN (2, 4);

-- int mean lots" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- int mean none" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = -1;
-- int mean one null" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 1;
-- int mean array of nulls" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 2;
-- int mean one not-null" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id = 4;
-- int mean array of nulls and one other" {
SELECT vec_to_mean(ints) FROM measurements WHERE sensor_id IN (2, 4);

-- bigint mean lots" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- bigint mean none" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = -1;
-- bigint mean one null" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 1;
-- bigint mean array of nulls" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 2;
-- bigint mean one not-null" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id = 4;
-- bigint mean array of nulls and one other" {
SELECT vec_to_mean(bigints) FROM measurements WHERE sensor_id IN (2, 4);

-- real mean lots" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- real mean none" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = -1;
-- real mean one null" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 1;
-- real mean array of nulls" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 2;
-- real mean one not-null" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id = 4;
-- real mean array of nulls and one other" {
SELECT vec_to_mean(reals) FROM measurements WHERE sensor_id IN (2, 4);

-- float8 mean lots" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (1, 2, 3, 4);
-- float8 mean none" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = -1;
-- float8 mean one null" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 1;
-- float8 mean array of nulls" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 2;
-- float8 mean one not-null" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id = 4;
-- float8 mean array of nulls and one other" {
SELECT vec_to_mean(floats) FROM measurements WHERE sensor_id IN (2, 4);
