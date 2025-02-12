\set ON_ERROR_STOP off

\copy history FROM 'history.csv' DELIMITER ',' CSV HEADER;

\copy history_uint FROM 'history_uint.csv' DELIMITER ',' CSV HEADER;

\copy history_log FROM 'history_log.csv' DELIMITER ',' CSV HEADER;

\copy history_text FROM 'history_text.csv' DELIMITER ',' CSV HEADER;

\copy history_str FROM 'history_str.csv' DELIMITER ',' CSV HEADER;

\copy history_bin FROM 'history_bin.csv' DELIMITER ',' CSV HEADER;

\copy trends FROM 'trends.csv' DELIMITER ',' CSV HEADER;

\copy trends_uint FROM 'trends_uint.csv' DELIMITER ',' CSV HEADER;
