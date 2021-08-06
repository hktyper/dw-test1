#!/bin/bash
  
# Turn on bash's job control
set -m

# The command will return local private ip address of the container, either aws Fargate or local docker container.
export CONNECT_REST_ADVERTISED_HOST_NAME=$(cat /etc/hosts | tail -1 | awk {'print $1'})

# Grab auth secrets from aws secrets manager and setup the AUTHENTICATION_TYPE secure environment. If no AUTHENTICATION_TYPE is provided skip and assume plaintext.
if [[ $AUTHENTICATION_TYPE == "SSL" ]]; then . get-secrets-ssl.sh
elif [[ $AUTHENTICATION_TYPE == "SASL" ]]; then . get-secrets-sasl.sh
else echo "START-UP WARNING: AUTHENTICATION_TYPE not provided or recoginized, assuming plaintext"
fi

# If these variables are not set, we should not start the rest API
# Note that the rest API will fail without these variables but it doesn't give a clear message
# so it's better to handle it
essential_variables=("CONNECT_BOOTSTRAP_SERVERS" "CONNECT_SECURITY_PROTOCOL"  "CONNECT_CONSUMER_SECURITY_PROTOCOL" "CONNECT_PRODUCER_SECURITY_PROTOCOL")
for var_name in "${essential_variables[@]}"; do
  [ -z "${!var_name}" ] && echo "$var_name is empty!" && var_unset=true
done
[ -n "$var_unset" ] && exit 1

# Start the base Kafka Connect Worker in background. This will start up the rest API needed to start the S3 Sink.
# All of the native scripts of Confluent image such as the ones validating the connection to BOOTSTRAP Server
# can be found in this path: /etc/confluent/docker
./etc/confluent/docker/run &
  
# Start the S3 Sink connector.
## it takes around a minute for Kafka Connect Worker to start, so better to wait before checking S3Sink otherwise we
## get connection refused error which can be confusing
wait_before_starting_s3sink=60 #in seconds
sleep $wait_before_starting_s3sink
./start-s3-sink.sh

# now we bring the primary process back into the foreground
# and leave it there
fg %1