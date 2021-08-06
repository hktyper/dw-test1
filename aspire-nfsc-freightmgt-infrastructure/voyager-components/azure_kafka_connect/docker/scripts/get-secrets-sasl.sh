#!/usr/bin/env bash

# Dependencies: jq, base64

set -e

# Check if secret required for SASL setup are provided, if not log message and exit
if [[ ! $SASL_SECRET ]]; then echo "GET-SECRETS-ERROR: Need to provide SASL_SECRET! The provided secrete needs to contain 2 keys: SASLUsername and SASLPassword... exiting..."; exit 1; fi

echo "GET-SECRETS-INFO: Getting secret from Secrets Manager: $SASL_SECRET"

# Grabbing the SASL user/pass from secrets manager. The secret requires specific key/value pairs named SASLUsername & SASLPassword to be picked up correctly.
SASL_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id $SASL_SECRET | jq -r '.SecretString')

SASL_USERNAME=$(echo $SASL_CREDENTIALS | jq -r '.SASLUsername') #API_KEY
SASL_PASSWORD=$(echo $SASL_CREDENTIALS | jq -r '.SASLPassword') #SECRET_KEY

if [[ ! $SASL_USERNAME || ! $SASL_PASSWORD ]]; then
  echo "GET-SECRETS-ERROR: SASL_USERNAME or SASL_PASSWORD is not parsed correctly! SASL_SECRET needs to contain 2 keys: SASLUsername and SASLPassword!"
  exit 1
fi

# might be needed but no clear Kafka Connect configuration for it
# ssl.endpoint.identification.algorithm=https

# Setting up the environment variables for SASL.
# Currently configured for SASL_SSL and PLAIN
export CONNECT_SASL_MECHANISM=PLAIN
export CONNECT_SECURITY_PROTOCOL=SASL_SSL
export CONNECT_SASL_JAAS_CONFIG='org.apache.kafka.common.security.plain.PlainLoginModule required username="'$SASL_USERNAME'" password="'$SASL_PASSWORD'";'

export CONNECT_ADMIN_SASL_MECHANISM=PLAIN
export CONNECT_ADMIN_SECURITY_PROTOCOL=SASL_SSL
export CONNECT_ADMIN_SASL_JAAS_CONFIG='org.apache.kafka.common.security.plain.PlainLoginModule required username="'$SASL_USERNAME'" password="'$SASL_PASSWORD'";'

export CONNECT_CONSUMER_SASL_MECHANISM=PLAIN
export CONNECT_CONSUMER_SECURITY_PROTOCOL=SASL_SSL
export CONNECT_CONSUMER_SASL_JAAS_CONFIG='org.apache.kafka.common.security.plain.PlainLoginModule required username="'$SASL_USERNAME'" password="'$SASL_PASSWORD'";'

export CONNECT_PRODUCER_SASL_MECHANISM=PLAIN
export CONNECT_PRODUCER_SECURITY_PROTOCOL=SASL_SSL
export CONNECT_PRODUCER_SASL_JAAS_CONFIG='org.apache.kafka.common.security.plain.PlainLoginModule required username="'$SASL_USERNAME'" password="'$SASL_PASSWORD'";'