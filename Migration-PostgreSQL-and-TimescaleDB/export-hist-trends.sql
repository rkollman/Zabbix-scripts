\set ON_ERROR_STOP on

\copy (select * from history_log) TO 'history_log.csv' DELIMITER ',' CSV;

\copy (select * from history) TO 'history.csv' DELIMITER ',' CSV;

\copy (select * from history_str) TO 'history_str.csv' DELIMITER ',' CSV;

\copy (select * from history_text) TO 'history_text.csv' DELIMITER ',' CSV;

\copy (select * from history_bin) TO 'history_bin.csv' DELIMITER ',' CSV;

\copy (select * from history_uint) TO 'history_uint.csv' DELIMITER ',' CSV;

\copy (select * from trends) TO 'trends.csv' DELIMITER ',' CSV;

\copy (select * from trends_uint) TO 'trends_uint.csv' DELIMITER ',' CSV;
