# Migrate Zabbix 6 on PostgreSQL & TimescaleDB to Zabbix 7 on another instance
How to migrate Zabbix 6 database on PostgreSQL with TimescaleDB to another instance and upgrade to Zabbix 7

The different versions of software which are used:

#### Zabbix 6 installation
- Zabbix 6.0.38
- PostgreSQL 15.10-1
- TimescaleDB 2.12.2
- Ubuntu 22.0.4.5 LTS

#### Zabbix 7 installation
- Zabbix 7.0.9
- PostgreSQL 16.6-1
- TimescaleDB 2.18.0
- Ubuntu 24.04.1 LTS

## Zabbix 6 server:

### Export dump compressed
First make a full backup without history and trends

`pg_dump -Fc -Z 5 -d zabbix --exclude-table-data=history* --exclude-table-data=trends*  --disable-triggers > zabbix_full-nohist.dump`

Or... make a full backup but disable TimescaleDB in this dump:

`pg_dump -Fc -Z 5 -d zabbix --exclude-table-data=history* --exclude-table-data=trends* -n public --disable-triggers > zabbix_full-nohist.dump`

When you use this TimescaleDB-disabled dump, doesn't need to have the TimescaleDB extension deleted in the next steps. You don't need to drop the TimescaleDB extension, but simple just activate this after importing the dump by doing the following on the Zabbix 7 server:

## Zabbix 7 server

```
sudo su - postgres
psql -d zabbix -X

CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
```

After this start Zabbix 7 server, wait for the upgrade to finish and stop it. Upgrade the TimescaleDB schema and start Zabbix 7 again. After this continue to import the CSV files.

## Zabbix 7 server

Create a Zabbix user and empty Zabbix database:
```
createuser --pwprompt zabbix
createdb -O zabbix zabbix
```

### Restore the created Zabbix 6 dump on the Zabbix 7 server

First make sure you copy the PostgreSQL dump file to the Zabbix 7 PostgreSQL server

`pg_restore -Fc -v -d zabbix zabbix_full-nohist.dump`

After restoring, start Zabbix 7, this will upgrade the Zabbix 6 database to Zabbix 7.

`systemctl start zabbix-server`

Look at the zabbix_server.log file. When the upgrade is finished, stop the zabbix server:

`systemctl stop zabbix-server`

```
sudo su - postgres
psql -d zabbix -X

drop extension timescaledb cascade;
exit
```

```
sudo su - postgres
psql -d zabbix -X

CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
```

Upgrade timescaledb schema:

`cat /usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql | sudo -u zabbix psql zabbix`


## Export and import history and trends after going live.
For this step, the export-hist-trends.sql and import-hist-trends.sql from this Github page can be used.

This can also be done on a later moment (even weeks later!) so no history of the "old" Zabbix server will be lost while building the new one!

### Steps to perform on the Zabbix 6 host:
Copy _export-hist-trends.sql_ to the postgresql home-directory.

```
sudo su - postgres
psql -U zabbix -h localhost -d zabbix -f export-hist-trends.sql
```

Copy csv files to the Zabbix 7 host

### Steps to perform on the Zabbix 7 host with empty history and trends tables
The following sql-script doesn't check for duplicate entries in the tables which you're importing the data in. So only use this one on empty history and trends tables.
Copy _import-hist-trends.sql_ to the postgresql home-directory. 

(-e is added to the psql-command for more verbose, to see what command is running as this takes a lot of time!):

This import can take quite some time (depending on the size of the history and trends tables) so starting this import with _screen_ or _tmux_ is strongly advised!

```
sudo su - postgres
psql -U zabbix -h localhost -d zabbix -e -f import-hist-trends.sql
```

### Steps to perform on the Zabbix 7 host when there is already data in the history and trends tables
The following sql-script checks for duplicate entries in the tables which you're importing the data in. If it finds items with data imported on a time for which also is data in the CSV-file, that specific data won't be imported to the tables.

So this script can be used on a already running Zabbix 7 host in which you want to import "old" history and trends data from your Zabbix 6 server.

Copy _import-hist-trends-no-duplicates.sql_ to the postgresql home-directory. 

This import can take quite some time (depending on the size of the history and trends tables) so starting this import with _screen_ or _tmux_ is strongly advised!

```
sudo su - postgres
psql -U zabbix -h localhost -d zabbix -e -f import-hist-trends-no-duplicates.sql
```
