#!/usr/bin/env bash

# Short description:
# Uses the local rest endpoint of the kafka-connect worker to start the s3-sink connector with the provided configuration ( see
# the json payload of the curl command )
# It sleeps for a couple of seconds and then retries again. Once the connector has started the script will stop.

sleep_time_seconds=${S3_SINK_LIVE_CHECK_SLEEP_TIME:=10}
success_http_code=200

S3SINK_PLUGIN=S3SinkConnector # use this parameter to check whether s3sink is installed
ERROR_MESSAGE="error_code"

private_hostname=${CONNECT_REST_ADVERTISED_HOST_NAME}":8083"

# Details on the environment variables you can use and what they're for can be found here: https://sainsburys-confluence.valiantys.net/display/LIME/Kafka+Connect+Configuration 
connector_config_body='{
    "connector.class": "io.confluent.connect.s3.S3SinkConnector",
    "tasks.max": "'"$KAFKA_CONNECT_S3_SINK_TASKS_MAX"'",
    "topics": "'"$KAFKA_CONNECT_S3_SINK_TOPICS"'",
    "s3.region": "'"$KAFKA_CONNECT_S3_SINK_AWS_REGION"'",
    "s3.bucket.name" : "'"$KAFKA_CONNECT_S3_SINK_S3_BUCKET"'",
    "s3.part.size" : 5242880,
    "flush.size" : "'"$KAFKA_CONNECT_S3_SINK_FLUSH_SIZE"'",
    "rotate.schedule.interval.ms" : "'"$KAFKA_CONNECT_S3_SINK_COMMIT_INTERVAL_MS"'",
    "timezone" : "UTC",
    "partitioner.class" : "io.confluent.connect.storage.partitioner.DailyPartitioner",
    "locale": "en_GB",
    "schema.compatibility" : "'"${KAFKA_CONNECT_S3_SINK_SCHEMA_COMPATIBILITY:=NONE}"'",
    "storage.class" : "io.confluent.connect.s3.storage.S3Storage",
    "format.class" : "'"${KAFKA_CONNECT_S3_SINK_FORMAT_CLASS:=io.confluent.connect.s3.format.json.JsonFormat}"'",
    "key.converter" : "'"${KAFKA_CONNECT_S3_SINK_KEY_CONVERTOR:=org.apache.kafka.connect.storage.StringConverter}"'",
    "value.converter" : "'"${KAFKA_CONNECT_S3_SINK_VALUE_CONVERTOR:=org.apache.kafka.connect.json.JsonConverter}"'",
    "key.converter.schemas.enable" : "'"${KAFKA_CONNECT_S3_SINK_KEY_CONVERTOR_SCHEMA:=false}"'",
    "value.converter.schemas.enable" : "'"${KAFKA_CONNECT_S3_SINK_VALUE_CONVERTOR_SCHEMA:=false}"'",
    "errors.log.enable" : "'"${KAFKA_CONNECT_S3_SINK_ERROR_LOG_ENABLE:=false}"'"
  }'

# Initial attempt to check if the server is up
response_http_code=$(curl -sL -w "%{http_code}" -I "$private_hostname" -o /dev/null)

# Not start any requests until Kafka Connect REST is ready
while ! [[ $response_http_code == $success_http_code ]]; do
    echo "S3-SINK INFO: Kafka Connect REST is not yet ready and HTTP Response is ${response_http_code}"
    echo "S3-SINK INFO: Sleeping: ${sleep_time_seconds}"
    sleep $sleep_time_seconds
    response_http_code=$(curl -sL -w "%{http_code}" -I "$private_hostname" -o /dev/null)
    if [[ $DEBUG == true ]]
    then
      full_response=$(curl "$private_hostname" )
      echo  "Full response: ${full_response}"
    fi
done

# Make sure S3-SINK plugin is installed
list_connectors_plugins=$(curl -X GET "$private_hostname"/connector-plugins -H 'Accept: application/json' -H 'Cache-Control: no-cache' -H 'Content-Type: application/json')
if ! [[ $list_connectors_plugins == *"$S3SINK_PLUGIN"* ]]; then
    echo "S3-SINK ERROR: Couldn't find S3 Sink plugin!"
    echo "S3-SINK ERROR: The installed plugins are: ${list_connectors_plugins}"
    echo "S3-SINK ERROR: Exiting..."
    exit 1
else
    echo "Successfully found S3-SINK plugin!"
fi

# List existing connectors
list_connectors_result=$(curl -X GET "$private_hostname"/connectors -H 'Accept: application/json' -H 'Cache-Control: no-cache' -H 'Content-Type: application/json')

# Create a new connector if current connector has not existed, otherwise update the config
if ! [[ $list_connectors_result == *"$KAFKA_CONNECT_S3_SINK_NAME"* ]]; then
    create_connector_result=$(curl -X POST "$private_hostname"/connectors -H 'Accept: application/json' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' -H 'Content-Type: application/json' -H 'cache-control: no-cache' -d ' {"name": "'"$KAFKA_CONNECT_S3_SINK_NAME"'","config": '"$connector_config_body"'}')
    if  [[ $create_connector_result == *"$ERROR_MESSAGE"* ]]; then
      echo "S3-SINK ERROR: ${create_connector_result}"
      echo "S3-SINK ERROR: Couldn't create connector: ${$KAFKA_CONNECT_S3_SINK_NAME} with below configuration: ${$connector_config_body}"
      exit 1
    fi
    echo "S3-SINK INFO: Created S3-Sink ${KAFKA_CONNECT_S3_SINK_NAME}"
else
    update_connector_result=$(curl -X PUT "$private_hostname"/connectors/"$KAFKA_CONNECT_S3_SINK_NAME"/config -H 'Accept: application/json' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' -H 'Content-Type: application/json' -H 'cache-control: no-cache' -d "$connector_config_body")
    if  [[ update_connector_result == *"$ERROR_MESSAGE"* ]]; then
      echo "S3-SINK ERROR: ${update_connector_result}"
      echo "S3-SINK ERROR: Couldn't update connector: ${$KAFKA_CONNECT_S3_SINK_NAME} with below configuration: ${$connector_config_body}"
      exit 1
    fi
    echo "S3-SINK INFO: Updated S3-Sink ${KAFKA_CONNECT_S3_SINK_NAME}'s config"
fi

list_connectors_result=$(curl -X GET "$private_hostname"/connectors -H 'Accept: application/json' -H 'Cache-Control: no-cache' -H 'Content-Type: application/json')
echo "S3-SINK INFO: Kafka Connect REST is on-line"
echo "S3-SINK INFO: Available S3-Sink(s) ${list_connectors_result}"