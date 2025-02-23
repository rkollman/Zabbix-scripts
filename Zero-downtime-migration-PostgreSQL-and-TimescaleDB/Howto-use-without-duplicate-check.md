# Migrate Zabbix 6 on PostgreSQL & TimescaleDB to Zabbix 7 on another instance
How to migrate Zabbix 6 database on PostgreSQL with TimescaleDB to another instance and upgrade to Zabbix 7 *without* duplicates checking.

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
First make a full backup without history and trends (and disable TimescaleDB by selecting the default schema *public*)

```
pg_dump -Fc -Z 5 -d zabbix --exclude-table-data=history* --exclude-table-data=trends* -n public --disable-triggers > zabbix_full-nohist.dump
```

When you use this TimescaleDB-disabled dump, after import you have to enable the TimescaleDB extension.

## Zabbix 7 server
Make sure the Zabbix user and database are created (I use the default username *zabbix* and database *zabbix* in this example)
```
sudo su - postgres
createuser --pwprompt zabbix
createdb -O zabbix zabbix
```
After this, import the Zabbix 6 dump

```
pg_restore -Fc -v -d zabbix zabbix_full-nohist.dump
```
Enable the TimescaleDB extension
```
sudo su - postgres
psql -d zabbix -X
\dx
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
\dx
\q
```

After this start Zabbix 7 server, wait for the upgrade to finish and stop it. Upgrade the TimescaleDB schema and start Zabbix 7 again. After this continue to import the CSV files.
```
sudo su -
systemctl start zabbix-server
sudo watch -n 1 grep 100% /var/log/zabbix/zabbix_server.log
```
If you see the upgrade is 100% finished, stop the Zabbix 7 server
```
sudo systemctl stop zabbix-server
```

### Apply TimescaleDB schema
Make sure the TimescaleDB schema of Zabbix is applied
```
cat /usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql | sudo -u zabbix psql zabbix
```

## Check Zabbix
Log-in to your new Zabbix 7 server and check if all hosts/templates/dashboards/etc. are migrated. You'll be missing history and trends data, this will be inserted in a following step.

# Migrate history and trends after going live.
For this step, the *export-hist-trends.sql* and *import-hist-trends.sql* from this Github page can be used.

This can also be done on a later moment (even weeks later!) so no history of the "old" Zabbix server will be lost while building the new one!

### Steps to perform on the Zabbix 6 host:
Copy _export-hist-trends.sql_ to the postgresql home-directory.

Make sure you have enough storage-space as the compressed Timescale-data will now be extracted and saved in uncompressed format (CSV).

```
sudo su - postgres
psql -U zabbix -h localhost -d zabbix -f export-hist-trends.sql
```
Copy the csv files to the Zabbix 7 host

### Steps to perform on the Zabbix 7 host with empty history and trends tables
The following sql-script doesn't check for duplicate entries in the tables which you're importing the data in. So only use this one on empty history and trends tables.

Copy _import-hist-trends.sql_ to the postgresql home-directory. 

Stop the Zabbix server and disable TimescaleDB which will drop the used tables. Afterwards enable TimescaleDB again and apply the timescaledb-schema:

```
sudo systemctl stop zabbix-server
sudo su - postgres
psql zabbix
drop extension timescaledb cascade;
\dx
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
sudo -i
cat /usr/share/zabbix-sql-scripts/postgresql/timescaledb/schema.sql | sudo -u zabbix psql zabbix
systemctl start zabbix-server
```

This import can take quite some time (depending on the size of the history and trends tables) so starting this import with _screen_ or _tmux_ is strongly advised!
```
sudo su - postgres
psql -U zabbix -h localhost -d zabbix -e -f import-hist-trends.sql
```
You can import the data while Zabbix 7 is online!

# Check Zabbix 7 history and trends
Once the import scripts have finished, you can check the history/trends graphs on you Zabbix 7 hosts. These will display all the data which were on the Zabbix 6 host.
