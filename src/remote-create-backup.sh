#!/bin/bash

########################################
#         Remote Backup Script
# This script will be executed on the server.
########################################

# PLEASE CHANGE THIS VARIABLES ACCORDING TO YOUR NEEDS.
PLESK_BACKUP_PATH=/var/lib/psa/dumps
UPLOADER_JAR=/PATH/TO/uploader-0.0.8-SNAPSHOT-jar-with-dependencies.jar
CREDENTIALS=/PATH/TO/aws.properties
AWS_VAULT=VAULTNAME
AWS_ENDPOINT="https://glacier.eu-west-1.amazonaws.com"
LOG=/PATH/TO/log.txt
EMAILTO="YOUR@EMAIL.TLD"

## Date and other variables, must not be changed!
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
MAILMSG="/tmp/glacier-upload-msg.txt"

cd $PLESK_BACKUP_PATH
# Find the latest backup file
LATEST_XML_FILE=$(ls -1tr *.xml | tail -1)
BACKUP_FILE=/tmp/$LATEST_XML_FILE.tar.gz
# Export the backup to a single file.
/opt/psa/admin/bin/plesk_agent_manager export-dump-as-file --dump-file-name $PLESK_BACKUP_PATH/$LATEST_XML_FILE -v \
--output-file $BACKUP_FILE

# Echo the filename so the local script can pick it up.
echo +++ Uploading to Amazon Glacier +++ >> $LOG
java -jar $UPLOADER_JAR --credentials $CREDENTIALS --endpoint $AWS_ENDPOINT --vault $AWS_VAULT \
--multipartupload $BACKUP_FILE --partsize 536870912 >> $LOG 2>&1

# Get Archive ID and prepare Mail MSG
echo "Archive ID: " > $MAILMSG
grep 'Upload Archive ID' $LOG | cut -f5 -d" " >> $MAILMSG
echo "\n\n" >> $MAILMSG
echo "Original Logfile:\n" >> $MAILMSG
$LOG >> $MAILMSG

echo $MAILMSG

# Send Mail with Archive ID to E-Mail Account.
mail -s "Glacier Backup for `hostname` - $DAY.$MONTH.$YEAR" $MAILTO < $MAILMSG

# Cleanup of files.
rm $BACKUP_FILE
rm $MAILMSG
echo "" > $LOG
