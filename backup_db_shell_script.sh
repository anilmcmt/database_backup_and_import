#!/bin/bash

################################################################
##   MySQL Database Backup Script 
##   Written By: Anil Yadav
################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

################################################################
################## Update Database config values  ########################

DB_BACKUP_PATH='/media/data/data/mysql/dbbackup203_93'
MYSQL_HOST='HOST'
MYSQL_PORT='3306'
MYSQL_USER='USER'
MYSQL_PASSWORD='PASSWORD'

BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy for delete backup

#########################create folder ########################################

mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"

for i in 'DB1' 'DB2' 'DB3' 'DB4'
do
  DATABASE_NAME=$i
  echo "running script for database export : $i"
  mysqldump --host=${MYSQL_HOST} \
		  --port=${MYSQL_PORT} \
		  --user=${MYSQL_USER} \
		  --password=${MYSQL_PASSWORD} \
		  --column-statistics=0 \
		  ${DATABASE_NAME}   > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql
		  
if [ $? -eq 0 ]; then
  echo "$i Database backup successfully completed"
else
  echo "$i Error occurred during database backup"
  exit 1
fi
done


####################################install db from backup script######################
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='USER'
MYSQL_PASSWORD='PASSWORD'
for i in 'DB1' 'DB2' 'DB3' 'DB4'
do
  DATABASE_NAME=$i		  
  echo "Looping  for installation ... number $i"
  mysql 	  -u ${MYSQL_USER} \
		  -p${MYSQL_PASSWORD} \
		  ${DATABASE_NAME}   < ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql
		  
if [ $? -eq 0 ]; then
  echo " $i Database imported successfully"
else
  echo "$i Error occurred during database import"
  exit 1
fi
done


##### Remove backups database than {BACKUP_RETAIN_DAYS} days  #####

#DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`

#if [ ! -z ${DB_BACKUP_PATH} ]; then
#      cd ${DB_BACKUP_PATH}
#      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
#            rm -rf ${DBDELDATE}
#      fi
#fi

### End of code ####
