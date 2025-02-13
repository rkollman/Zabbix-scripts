\set ON_ERROR_STOP off

CREATE TEMPORARY TABLE temp_history AS
    SELECT * FROM history
    WITH NO DATA;

\copy temp_history FROM 'history.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history
    SELECT * FROM temp_history
    WHERE clock NOT IN (
      SELECT clock FROM history
    );

CREATE TEMPORARY TABLE temp_history_uint AS
    SELECT * FROM history_uint
    WITH NO DATA;

\copy temp_history_uint FROM 'history_uint.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history_uint
    SELECT * FROM temp_history_uint
    WHERE clock NOT IN (
      SELECT clock FROM history_uint
    );

CREATE TEMPORARY TABLE temp_history_log AS
    SELECT * FROM history_log
    WITH NO DATA;

\copy temp_history_log FROM 'history_log.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history_log
    SELECT * FROM temp_history_log
    WHERE clock NOT IN (
      SELECT clock FROM history_log
    );

CREATE TEMPORARY TABLE temp_history_text AS
    SELECT * FROM history_text
    WITH NO DATA;

\copy temp_history_text FROM 'history_text.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history_text
    SELECT * FROM temp_history_text
    WHERE clock NOT IN (
      SELECT clock FROM history_text
    );

CREATE TEMPORARY TABLE temp_history_str AS
    SELECT * FROM history_str
    WITH NO DATA;

\copy temp_history_str FROM 'history_str.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history_str
    SELECT * FROM temp_history_str
    WHERE clock NOT IN (
      SELECT clock FROM history_str
    );

CREATE TEMPORARY TABLE temp_history_bin AS
    SELECT * FROM history_bin
    WITH NO DATA;

\copy temp_history_bin FROM 'history_bin.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO history_bin
    SELECT * FROM temp_history_bin
    WHERE clock NOT IN (
      SELECT clock FROM history_bin
    );

CREATE TEMPORARY TABLE temp_trends AS
    SELECT * FROM trends
    WITH NO DATA;

\copy temp_trends FROM 'trends.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO trends
    SELECT * FROM temp_trends
    WHERE clock NOT IN (
      SELECT clock FROM trends
    );

CREATE TEMPORARY TABLE temp_trends_uint AS
    SELECT * FROM trends_uint
    WITH NO DATA;

\copy temp_trends_uint FROM 'trends_uint.csv' DELIMITER ',' CSV HEADER;

  INSERT INTO trends_uint
    SELECT * FROM temp_trends_uint
    WHERE clock NOT IN (
      SELECT clock FROM trends_uint
    );
