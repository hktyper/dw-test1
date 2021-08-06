#!/bin/bash

CONTAINERS='containers'
ORDERLINES='orderlines'
EXCEPTIONS='exceptions'
SHIPMENTS='shipments'
ALLOCATIONS='allocations'
DPP_BUCKET="dpp2-prd-raw-src-freight-mgmt"
LOCAL_BUCKET="prod-raw-src-freightmgt-local"

HOME="/home/ubuntu"
DIR="/home/ubuntu/codebase"
DOWNLOADER="${DIR}/aspire-nfsc-freightmgt-api-downloader-service"
TRANSCODER="${DIR}/aspire-nfsc-freightmgt-transcoder-service"
DATE_FORMAT="%Y-%m-%d %H:%M:%S"

date=$(date +"%Y-%m-%d")
hour=$(date +"%H")

cd $TRANSCODER;

echo "$(date +"${DATE_FORMAT}") Starting the transcoder, accessing ${CONTAINERS}.csv from ${LOCAL_BUCKET}/${date}/${hour}"
rm -rf $HOME/logs/transcoder/$CONTAINERS
pipenv run python -m transcoder --region eu-west-1 --tgt-bucket $DPP_BUCKET --tgt-prefix outputs/$date/$hour --enable-copy one-off --src-bucket $LOCAL_BUCKET --src-prefix  $date/$hour --table-name $CONTAINERS &>> $HOME/logs/transcoder/$CONTAINERS &
echo "$(date +"${DATE_FORMAT}") Transcoding finished for ${CONTAINERS}"

echo "$(date +"${DATE_FORMAT}") Starting the transcoder, accessing ${EXCEPTIONS}.csv from ${LOCAL_BUCKET}/${date}/${hour}"
rm -rf $HOME/logs/transcoder/$EXCEPTIONS
pipenv run python -m transcoder --region eu-west-1 --tgt-bucket $DPP_BUCKET --tgt-prefix outputs/$date/$hour --enable-copy one-off --src-bucket $LOCAL_BUCKET --src-prefix  $date/$hour --table-name $EXCEPTIONS &>> $HOME/logs/transcoder/$EXCEPTIONS &
echo "$(date +"${DATE_FORMAT}") Transcoding finished for ${EXCEPTIONS}"

echo "$(date +"${DATE_FORMAT}") Starting the transcoder, accessing ${SHIPMENTS}.csv from ${LOCAL_BUCKET}/${date}/${hour}"
rm -rf $HOME/logs/transcoder/$SHIPMENTS
pipenv run python -m transcoder --region eu-west-1 --tgt-bucket $DPP_BUCKET --tgt-prefix outputs/$date/$hour --enable-copy one-off --src-bucket $LOCAL_BUCKET --src-prefix  $date/$hour --table-name $SHIPMENTS --pii-keys Active_Task_Assigned_User &>> $HOME/logs/transcoder/$SHIPMENTS &
echo "$(date +"${DATE_FORMAT}") Transcoding finished for ${SHIPMENTS}"

echo "$(date +"${DATE_FORMAT}") Starting the transcoder, accessing ${ALLOCATIONS}.csv from ${LOCAL_BUCKET}/${date}/${hour}"
rm -rf $HOME/logs/transcoder/$ALLOCATIONS
pipenv run python -m transcoder --region eu-west-1 --tgt-bucket $DPP_BUCKET --tgt-prefix outputs/$date/$hour --enable-copy one-off --src-bucket $LOCAL_BUCKET --src-prefix  $date/$hour --table-name $ALLOCATIONS --pii-keys Merchandiser &>> $HOME/logs/transcoder/$ALLOCATIONS &
echo "$(date +"${DATE_FORMAT}") Transcoding finished for ${ALLOCATIONS}"

echo "$(date +"${DATE_FORMAT}") Starting the transcoder, accessing ${ORDERLINES}.csv from ${LOCAL_BUCKET}/${date}/${hour}"
rm -rf $HOME/logs/transcoder/$ORDERLINES
pipenv run python -m transcoder \
  --region eu-west-1 \
  --tgt-bucket $DPP_BUCKET \
  --tgt-prefix outputs/$date/$hour \
  --enable-copy \
  one-off \
  --src-bucket $LOCAL_BUCKET \
  --src-prefix  $date/$hour \
  --table-name $ORDERLINES \
  --pii-keys Merchandiser Last_Import_Date Branded Order_Number eSOP_Conditional_Setup_Order_Acceptance \
  &>> $HOME/logs/transcoder/$ORDERLINES
echo "$(date +"${DATE_FORMAT}") Transcoding finished for ${ORDERLINES}"
