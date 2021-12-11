BEGIN; 

DROP TABLE IF EXISTS measurements;
CREATE TABLE measurements (
  sensor_id INTEGER NOT NULL,
  measured_at TIMESTAMP WITH TIME ZONE,
  floats FLOAT[],
  nums NUMERIC[]
);

INSERT INTO measurements
(sensor_id, measured_at, floats, nums)
SELECT  1,
        '2000-01-01'::timestamptz + concat(a, ' seconds')::interval,
        ARRAY[random(), random(), random(), random(), random(),
              random(), random(), random(), random(), random()],
        ARRAY[
          -- introduce randomness in scale and drop trailing zeros via to_char
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric,
          to_char(round(random()::numeric * 1000000, floor(random() * 16)::integer), 'FM99999990.9999999999999999')::numeric]
FROM    generate_series(1, 1000000) AS s(a)
;

CREATE INDEX idx_measurements_sensor_id ON measurements (sensor_id, measured_at);
COMMIT;

