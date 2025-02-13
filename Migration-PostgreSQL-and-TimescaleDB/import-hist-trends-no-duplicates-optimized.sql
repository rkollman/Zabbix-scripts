\set ON_ERROR_STOP on
\set temp_buffers = '500MB';

BEGIN;

-- Increase maintenance work memory
SET maintenance_work_mem = '1GB';

-- Process history_uint
CREATE TEMPORARY TABLE temp_history_uint AS
    SELECT * FROM history_uint
    WITH NO DATA;
\copy temp_history_uint FROM 'history_uint.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history_uint
    SELECT t.*
    FROM temp_history_uint t
    LEFT JOIN history_uint h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history_uint;

-- Process history
CREATE TEMPORARY TABLE temp_history AS
    SELECT * FROM history
    WITH NO DATA;
\copy temp_history FROM 'history.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history
    SELECT t.*
    FROM temp_history t
    LEFT JOIN history h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history;

-- Process history_log
CREATE TEMPORARY TABLE temp_history_log AS
    SELECT * FROM history_log
    WITH NO DATA;
\copy temp_history_log FROM 'history_log.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history_log
    SELECT t.*
    FROM temp_history_log t
    LEFT JOIN history_log h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history_log;

-- Process history_text
CREATE TEMPORARY TABLE temp_history_text AS
    SELECT * FROM history_text
    WITH NO DATA;
\copy temp_history_text FROM 'history_text.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history_text
    SELECT t.*
    FROM temp_history_text t
    LEFT JOIN history_text h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history_text;

-- Process history_str
CREATE TEMPORARY TABLE temp_history_str AS
    SELECT * FROM history_str
    WITH NO DATA;
\copy temp_history_str FROM 'history_str.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history_str
    SELECT t.*
    FROM temp_history_str t
    LEFT JOIN history_str h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history_str;

-- Process history_bin
CREATE TEMPORARY TABLE temp_history_bin AS
    SELECT * FROM history_bin
    WITH NO DATA;
\copy temp_history_bin FROM 'history_bin.csv' DELIMITER ',' CSV HEADER;
INSERT INTO history_bin
    SELECT t.*
    FROM temp_history_bin t
    LEFT JOIN history_bin h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_history_bin;

-- Process trends
CREATE TEMPORARY TABLE temp_trends AS
    SELECT * FROM trends
    WITH NO DATA;
\copy temp_trends FROM 'trends.csv' DELIMITER ',' CSV HEADER;
INSERT INTO trends
    SELECT t.*
    FROM temp_trends t
    LEFT JOIN trends h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_trends;

-- Process trends_uint
CREATE TEMPORARY TABLE temp_trends_uint AS
    SELECT * FROM trends_uint
    WITH NO DATA;
\copy temp_trends_uint FROM 'trends_uint.csv' DELIMITER ',' CSV HEADER;
INSERT INTO trends_uint
    SELECT t.*
    FROM temp_trends_uint t
    LEFT JOIN trends_uint h ON t.clock = h.clock
    WHERE h.clock IS NULL;
DROP TABLE temp_trends_uint;

COMMIT;
