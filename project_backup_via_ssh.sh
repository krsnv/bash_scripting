#!/bin/bash

# example.ru EVERYDAY BACKUP
# --------------------------
#
# This script needs SSH key to authorize on project server.
# Generate SSH key, add it on project server and configure Host in ~/.ssh/config


source ~/TelegramBot.tokens

# ------------------------------------------------------------------------------
# SCRIPT PARAMS

PROJECT_DOMAIN="example.ru"
PROJECT_HOST="user@example.ru"

SOURCE_DIR="/server/path/"
BACKUP_DIR="/path/to/backup/tar/gz"

TIME_FORMAT=$(date +%H:%M:%S)

ARCHIVE_NAME=$(date +%Y-%m-%d).tar.gz;
SQL_NAME=$(date +%Y-%m-%d).sql.gz;

DB_USER=""
DB_PASS=""
DB_HOST=""
DB_NAME=""


# ------------------------------------------------------------------------------
# Send notification to Telegram Chat

function sendNotification()
{
    OPERATION_STATUS=$1
    ARTIFACTS=$2
    MESSAGE="${OPERATION_STATUS} — ${PROJECT_DOMAIN} (${ARTIFACTS} backup) ${TIME_FORMAT}"
    wget --tries=3 --timeout=5 -O /dev/null  \
    "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${CHAT_ID}&text=${MESSAGE}&disable_web_page_preview=true"
}


# ------------------------------------------------------------------------------
# Removing old backups

function removeOlderThenFiveDays()
{
    find ${BACKUP_DIR}/files/* -mtime +5 -exec rm {} \;
    find ${BACKUP_DIR}/db/* -mtime +5 -exec rm {} \;
}


# ------------------------------------------------------------------------------
# Create archive with project files

function makeFilesBackup()
{
    ssh ${PROJECT_HOST} "tar cvfz - ${SOURCE_DIR} --exclude=migration" > ${BACKUP_DIR}/files/${ARCHIVE_NAME}
}


# ------------------------------------------------------------------------------
# Create archive with database

function makeDatabaseBackup()
{
    ssh ${PROJECT_HOST} "mysqldump -u${DB_USER} -p${DB_PASS} ${DB_NAME} | gzip -3 -c" > ${BACKUP_DIR}/db/$SQL_NAME
}



# ------------------------------------------------------------------------------
# BACKUP PROCESS

makeFilesBackup
makeDatabaseBackup

if [[ -f ${BACKUP_DIR}/files/$ARCHIVE_NAME ]]; then
    sendNotification ok files
else
    sendNotification FAIL files
fi

if [[ -f ${BACKUP_DIR}/db/$SQL_NAME ]]; then
    sendNotification ok db
else
    sendNotification FAIL db
fi

removeOlderThenFiveDays
