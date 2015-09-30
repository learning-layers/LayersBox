#!/bin/bash

echo Creating databases and generating new passwords for services
mkdir -p tmp/sqlfile
echo "" > tmp/secret.env
TMP_SQLFILE=tmp/sqlfile/db.sql
rm -rf $TMP_SQLFILE
unset DOBACKUP
# Read all lines from databases file (see after end of loop)
echo $(pwd)
cat databases
while read -u "$fd_num" servicevar; do
    echo Processing $servicevar
    unset SERVICE_PASS SERVICE_USER SERVICE_DB_NAME TMP_SERVICE_DB TMP_SERVICE_USER
    TMPSERV=($servicevar)
    filename=${TMPSERV[0]}
    # Source the current .env file to have all needed variables
    source "${filename}"
    DB_DIR=${filename%/*}
    DBS=${#TMPSERV[@]}
    # Loop over all DBs contained in one .env file (Usually only 1)
    for (( i = 1; i < $DBS; i++ )); do
        service=${TMPSERV[$i]}
        TEST_SERVICE_PASS=${service}_DB_PASS
        TMP_SERVICE_EXISTS=${service}_DB_EXISTS
        # Don't do anything if the user already has a password and database is created
        if [[ -n ${!TEST_SERVICE_PASS} && -n ${!TMP_SERVICE_EXISTS} ]]; then
            continue
            unset SERVICE_PASS SERVICE_USER SERVICE_DB_NAME TMP_SERVICE_DB TMP_SERVICE_USER
        fi
        DOBACKUP="BACKUP"
        echo Service: ${service}
        # Do some Magic with variable names here to have variable variable names... (Arrays essentially)
        # We need this because we sourced the .env file and every service can have multiple and 
        # different database names
        TMP_SERVICE_USER=${service}_DB_USER
        TMP_SERVICE_DB=${service}_DB_NAME
        SERVICE_DB_USER=${!TMP_SERVICE_USER}
        SERVICE_DB_NAME=${!TMP_SERVICE_DB}
        SERVICE_DB_EXISTS=${!TMP_SERVICE_EXISTS}
        echo $SERVICE_DB_EXISTS
        # If DB has not been created yet, use an SQL file from the same directory as the .env file.
        # The file has to be called X.sql when the DB is called X
        if [[ -z "$SERVICE_DB_EXISTS" ]]; then
            echo "Copying ${DB_DIR}/${service}.sql to ${TMP_SQLFILE}"
            cp ${DB_DIR}/${service}.sql ${TMP_SQLFILE}
        else
            echo "DB exists"
        fi
        # Write credentials to temporary file for docker-compose
        echo "SERVICE_DB_USER=${SERVICE_DB_USER}" > tmp/secret.env
        echo "SERVICE_DB_NAME=${SERVICE_DB_NAME}" >> tmp/secret.env
        echo "SERVICE_DB_EXISTS=${SERVICE_DB_EXISTS}" >> tmp/secret.env
        rm -f ./mysql-data/backup/mysql.attic.latest ./mysql-data/backup/mysql-backup.tar.xz
        # Create database and extract the password
        CREATE_OUTPUT="$(docker-compose run mysqlcreate)"
        echo "$CREATE_OUTPUT"
        SERVICE_PASS=$(echo "$CREATE_OUTPUT" | grep "mysql" | awk '{split($0,a," "); print a[3]}' | cut -c3-)
        # rm -rf $TMP_SQLFILE
        sed -i ${filename} -e "/${service}_DB_PASS/d" -e "/${service}_DB_EXISTS/d"
        echo "${service}_DB_PASS=${SERVICE_PASS}" >> ${filename}
        echo "${service}_DB_EXISTS=1" >> ${filename}
        echo Generated password ${SERVICE_PASS} for service $service
        echo Finished service: ${service}
        # read blablablabla
        unset SERVICE_PASS SERVICE_USER SERVICE_DB_NAME TMP_SERVICE_DB TMP_SERVICE_USER
    done
done {fd_num}<$(pwd)/databases
# if [[ -n ${DOBACKUP} ]]; then
#     ./backup.sh
# fi
# echo "" > tmp/secret.env
echo " " > $TMP_SQLFILE
