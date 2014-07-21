#!/bin/bash

# --------------------------------------------------------------------------------------
# Send backups of the configuration and data on this server to a backup server.
# The backups should be sufficient to enable this server to be rebuilt from the backups.
#
# The plan is to:
# 1. Put some extra configuration details into /var/backups
# 2. Put Postgresql/MySQL database backups into /var/backups
# 3. Synchronise various directories to the backup server.
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# Preparation
# 1. Ensure the mysql command can run as root without any password being input.
# 2. Ensure the psql command can run as root without any password being input.
# --------------------------------------------------------------------------------------

SERVER="thisservername"
REMOTE_SRV="backupserver.example.com"

# List of locations which will be backed up.
Locations=(/etc /usr/local /var/backups /home)

# --------------------------------
# 1. Put extra data into /var/backups
# --------------------------------
echo
echo `date`
echo "Put current package listing for the server into /var/backups..."
dpkg --get-selections > /var/backups/dpkg_selections.txt

## --------------------------------
## 2a. Dump postgresql databases into /var/backups
## --------------------------------
###echo
###echo `date`
###echo "Dump Postgresql databases into /var/backups..."
###mkdir -p /var/backups/postgresql_backups
#### Here we loop through a list of databases - the flags cut out most formatting from the database list produced.
###for db_name in $(psql -U phppgadmin -A -t --command "SELECT datname FROM pg_catalog.pg_database ORDER BY datname;" template1)
###  do

###  if [ $db_name != 'postgres' -a $db_name != 'template0' -a $db_name != 'template1' ]; then

###       echo
###       echo `date`
###       echo "Dumping out Postgresql database: ${db_name} ..."
###       pg_dump -U phppgadmin --blobs --format=c ${db_name} > /var/backups/postgresql_backups/${db_name}.pgd

###  fi

###done

# --------------------------------
# 2b. Dump MySQL databases into /var/backups
# --------------------------------
echo
echo `date`
echo "Dump MySQL databases into /var/backups..."
# This creates a safety dump of all MySQL databases.
mkdir -p /var/backups/mysql_backups
mysqldump --flush-privileges --all-databases --hex-blob -c --add-drop-table --opt --routines > /var/backups/mysql_backups/mysql_dumpall.sql

# This creates separate mysql dump files.
databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

# Dump each database in turn.
for db in $databases; do

  if [ $db != 'information_schema' ]; then

    echo "Dumping out MySQL database: ${db} ..."
    mysqldump --databases $db > /var/backups/mysql_backups/${db}.bak
  fi

done

# --------------------------------------------------------
# 3. Synchronise various directories to the backup server.
# --------------------------------------------------------
echo
echo `date`
echo "Copying data to backup server ${REMOTE_SRV}"
for DIR in ${Locations[*]}
do
   echo
   echo "Backing up ${DIR} to ${REMOTE_SRV}..."
   rsync -avz --delete ${DIR}/ ${SERVER}@${REMOTE_SRV}:backups${DIR};
done

echo
echo `date`
echo "Finished"
