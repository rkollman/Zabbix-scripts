# How to migrate Zabbix 6 database on PostgreSQL with TimescaleDB to another instance and upgrade to Zabbix 7

## Zabbix 6 server:

### Export schema
pg_dump -Fp -s -d zabbix -U zabbix -h localhost > zabbix_schema.sql

### Export data without history and trends
pg_dump -Fp -d zabbix -T history* -T trends* > zabbix_data.sql

## Zabbix 7 server

### Import schema

