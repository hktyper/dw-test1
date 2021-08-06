FROM confluentinc/cp-kafka-connect-base:5.5.3

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:5.5.3


RUN apt-get -qq update && \
	apt-get install -qq jq unzip
# This is needed to get secret variables from AWS
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.1.18.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install 

# Details on the environment variables you can use and what they're for can be found here: https://sainsburys-confluence.valiantys.net/display/LIME/Kafka+Connect+Configuration 
####DOCKER COMPOSE ENV START######
ENV CONNECT_KEY_CONVERTER=org.apache.kafka.connect.storage.StringConverter
ENV CONNECT_VALUE_CONVERTER=org.apache.kafka.connect.json.JsonConverter

# The internal converters are deprecated as of Kafka 2.0, therefore we don't set variables
# like CONNECT_INTERNAL_KEY_CONVERTER, CONNECT_INTERNAL_VALUE_CONVERTER, CONNECT_INTERNAL_KEY_CONVERTER_SCHEMAS_ENABLE and CONNECT_INTERNAL_VALUE_CONVERTER_SCHEMAS_ENABLE
# See this for reference: https://www.confluent.io/blog/kafka-connect-deep-dive-converters-serialization-explained/#internal-converters
ENV CONNECT_KEY_CONVERTER=org.apache.kafka.connect.storage.StringConverter
ENV CONNECT_VALUE_CONVERTER=org.apache.kafka.connect.json.JsonConverter
ENV CONNECT_PLUGIN_PATH=/usr/share/java,/usr/share/confluent-hub-components
ENV CONNECT_LOG4J_LOGGERS=org.apache.zookeeper=ERROR,org.I0Itec.zkclient=ERROR,org.reflections=ERROR,org.apache.kafka.connect=ERROR


####DOCKER COMPOSE ENV END######

ADD scripts/start-up.sh start-up.sh
ADD scripts/get-secrets-ssl.sh get-secrets-ssl.sh
ADD scripts/get-secrets-sasl.sh get-secrets-sasl.sh
ADD scripts/start-s3-sink.sh start-s3-sink.sh

RUN chmod +x start-up.sh && \
    chmod +x get-secrets-ssl.sh && \
    chmod +x get-secrets-sasl.sh && \
    chmod +x start-s3-sink.sh

EXPOSE 8083

ENTRYPOINT /bin/bash ./start-up.sh