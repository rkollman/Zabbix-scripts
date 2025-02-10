\set ON_ERROR_STOP off

\copy history FROM 'history.csv' DELIMITER ',' CSV;

\copy history_uint FROM 'history_uint.csv' DELIMITER ',' CSV;

\copy history_log FROM 'history_log.csv' DELIMITER ',' CSV;

\copy history_text FROM 'history_text.csv' DELIMITER ',' CSV;

\copy history_str FROM 'history_str.csv' DELIMITER ',' CSV;

\copy history_bin FROM 'history_bin.csv' DELIMITER ',' CSV;

\copy trends FROM 'trends.csv' DELIMITER ',' CSV;

\copy trends_uint FROM 'trends_uint.csv' DELIMITER ',' CSV;
