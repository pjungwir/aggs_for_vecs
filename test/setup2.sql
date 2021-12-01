BEGIN; 

DROP TABLE IF EXISTS measurements2;
CREATE TABLE measurements2 (
  stream_id TEXT NOT NULL,
  ts TIMESTAMP WITH TIME ZONE NOT NULL,
  data_i NUMERIC[],
  data_a NUMERIC[],
  data_s TEXT[],
  PRIMARY KEY (stream_id, ts)  
);

\copy measurements2 FROM 'test/setup-data-01.csv' DELIMITER ',' CSV HEADER

COMMIT;
