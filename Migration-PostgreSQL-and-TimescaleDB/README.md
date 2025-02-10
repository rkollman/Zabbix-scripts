# How to migrate Zabbix 6 database on PostgreSQL with TimescaleDB to another instance and upgrade to Zabbix 7

## Zabbix 6 server:

#### Export dump compressed
Only schema
pg_dump -Fc -Z 5 -s -d zabbix --disable-triggers > zabbix_schema.dump
Full backup without history and trends
pg_dump -Fc -Z 5 -d zabbix --exclude-table-data=history* --exclude-table-data=trends*  --disable-triggers > zabbix_full-nohist.dump

Full dump
pg_dump -Fc -Z 5 -d zabbix --disable-triggers > zabbix_full.dump

## Zabbix 7 server

First create a Zabbix user and empty database:
createuser --pwprompt zabbix
createdb -O zabbix zabbix

#CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

#### Custom format compressed restore
pg_restore -Fc -v -s -d zabbix zabbix_schema.dump
pg_restore -Fc -v -d zabbix zabbix_full.dump
# Start Zabbix 7 (upgrade database)
systemctl start zabbix-server

psql -d zabbix -X
drop extension timescaledb cascade;

psql -d zabbix -X
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
Upgrade timescaledb schema:
cat /usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql | sudo -u zabbix psql zabbix



## Export and import history and trends after going live

import csv-files;

Do this on the Zabbix 6 host:
psql -U zabbix -h localhost -d zabbix -f export-hist-trends.sql

Copy csv files to the Zabbix 7 host (-e is for more verbose, to see what command is running as this takes a lot of time!):
psql -U zabbix -h localhost -d zabbix -e -f import-hist-trends.sql



