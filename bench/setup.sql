BEGIN; 

DROP TABLE IF EXISTS measurements;
CREATE TABLE measurements (
  sensor_id INTEGER NOT NULL,
  measured_at TIMESTAMP WITH TIME ZONE,
  floats FLOAT[]
);

INSERT INTO measurements
(sensor_id, measured_at, floats)
SELECT  1,
        '2000-01-01'::timestamptz + concat(a, ' seconds')::interval,
        ARRAY[random(), random(), random(), random(), random(),
              random(), random(), random(), random(), random()]
FROM    generate_series(1, 1000000) AS s(a)
;

CREATE INDEX idx_measurements_sensor_id ON measurements (sensor_id, measured_at);
COMMIT;

