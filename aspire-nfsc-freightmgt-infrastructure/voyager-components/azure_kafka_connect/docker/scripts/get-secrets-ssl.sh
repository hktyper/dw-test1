#!/usr/bin/env bash

# Dependencies: jq, base64

set -e

# Check if both secrets required for SSL setup are provided, if not log message and exit
if [[ ! $KEYSTORE_SECRET || ! $KEYSTORE_PASS_SECRET ]]; then echo "ERROR: Need to provide KEYSTORE SECRET and KEYSTORE_PASS_SECRET... exiting..."; exit 1; fi

echo "INFO: Getting secrets from Secrets Manager: $KEYSTORE_SECRET, $KEYSTORE_PASS_SECRET"

# Grabbing the keystore from secrets manager and creating a file to hold the value.
# Instructions on creating a keystore file can be found here: https://sainsburys-confluence.valiantys.net/display/LIME/Creating+SSL+Certificate+and+Keystore
aws secretsmanager get-secret-value --secret-id $KEYSTORE_SECRET | jq -r '.SecretBinary' | base64 -d > kafka.connect.keystore.jks

# Grabbing the keystore passwords from secrets manager. The secret requires specific key/value pairs named KeystorePassword & KeyPassword to be picked up correctly.
SECRET_PASSWORDS=$(aws secretsmanager get-secret-value --secret-id $KEYSTORE_PASS_SECRET | jq -r '.SecretString')

KEYSTORE_PASSWORD=$(echo $SECRET_PASSWORDS | jq -r '.KeystorePassword')
KEY_PASSWORD=$(echo $SECRET_PASSWORDS | jq -r '.KeyPassword')

# Setting up the environment variables for SSL.
export CONNECT_SECURITY_PROTOCOL=SSL
export CONNECT_SSL_KEYSTORE_LOCATION=kafka.connect.keystore.jks
export CONNECT_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_SSL_KEY_PASSWORD=$KEY_PASSWORD

export CONNECT_ADMIN_SECURITY_PROTOCOL=SSL
export CONNECT_ADMIN_SSL_KEYSTORE_LOCATION=kafka.connect.keystore.jks
export CONNECT_ADMIN_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_ADMIN_SSL_KEY_PASSWORD=$KEY_PASSWORD

export CONNECT_CONSUMER_SECURITY_PROTOCOL=SSL
export CONNECT_CONSUMER_SSL_KEYSTORE_LOCATION=kafka.connect.keystore.jks
export CONNECT_CONSUMER_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_CONSUMER_SSL_KEY_PASSWORD=$KEY_PASSWORD

export CONNECT_PRODUCER_SECURITY_PROTOCOL=SSL
export CONNECT_PRODUCER_SSL_KEYSTORE_LOCATION=kafka.connect.keystore.jks
export CONNECT_PRODUCER_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD
export CONNECT_PRODUCER_SSL_KEY_PASSWORD=$KEY_PASSWORD