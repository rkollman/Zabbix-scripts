# How to migrate Zabbix 6 database on PostgreSQL with TimescaleDB to another instance and upgrade to Zabbix 7

## Zabbix 6 server:

### Export schema
#### Plain text
pg_dump -Fp -s -d zabbix -U zabbix -h localhost > zabbix_schema.sql

#### Custom format compressed
pg_dump -Fc -Z 5 -v -s -d zabbix -U zabbix -h localhost > zabbix_schema.dump

### Export data without history and trends
#### Plain text
pg_dump -Fp -d zabbix -T history* -T trends* > zabbix_data.sql

#### Custom format compressed
pg_dump -Fc -Z 5 -v -d zabbix -U zabbix -h localhost -T history* -T trends* > zabbix_data.dump

## Zabbix 7 server

First create a Zabbix user and empty database:
createuser --pwprompt zabbix
createdb -O zabbix zabbix

su - postgres
psql -d zabbix
CREATE EXTENSION IF NOT EXISTS timescaledb;
SELECT timescaledb_pre_restore();

### Import schema from Zabbix 6 server:


### Set timescale restore mode off:
psql -d zabbix
SELECT timescaledb_post_restore();

