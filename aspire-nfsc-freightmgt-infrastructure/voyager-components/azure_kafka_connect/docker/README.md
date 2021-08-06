## Kafka Connect
This docker image contains a baseline Kafka Connect S3 Sink Worker, the container can connect to a set of Kafka Topics and will dump the data to S3 with minimal configuration. This image is pre-configured to read and write in JSON. 
However, it can be configured with different converters. In order to change the format of the output file, 
you need to set KAFKA_CONNECT_S3_SINK_FORMAT_CLASS environment variable.

The image is designed with reuseability in mind and can be easily configured by feeding a set of environment variables to the container. Allowing this same base image to be re-used for different connections/use-cases. For example in AWS we can set up a single image in ECR and create multiple task definitions with different environment variables for each different use-case.

There are three scripts used by the docker image:
- start-up.sh a wrapper used to start up the base Kafka Connect worker and call the other scripts.
- get-secrets-(ssl/sasl).sh connects to secrets manager and sets up the environment variables required for SSH.
- start-s3-sink.sh starts up the s3 sink connector.

### Set-up
To configure the container for use a set of environment variables are needed. Documentation on what variables are required and what they are used for can be found here: [Kafka Connect Configuration](https://sainsburys-confluence.valiantys.net/display/LIME/Kafka+Connect+Configuration)

These must be fed through when creating the container, there are no default values provided (apart from SSL configuration which is optional).

### SSL Authentication (Optional)
To use SSL with this container you must provide AWS secrets that contain a valid keystore file to use and keystore file passwords. Information on how to pass these to the container are documented in the link from set-up above. If these are not provided plaintext is assumed and no further config is required.

A guide on how to create a keystore file and certificate can be found here: [Creating SSL Certificate and Keystore](https://sainsburys-confluence.valiantys.net/display/LIME/Creating+SSL+Certificate+and+Keystore)

### SASL Authentication (Optional)
Dependant on your authentication you may or may not need to use SASL.
https://docs.confluent.io/platform/current/connect/security.html
To use SASL you must provide an AWS secret that contains SASLUsername and SASLPassword keys with their relevant values.
The MECHANISM is set to PLAIN by default. Check get-secrets-sasl.sh file for more information.

### Local Environment
A docker-compose file has also been provided to test out development locally. This docker-compose file creates the Kafka Connect container alongside containers for Kafka Core and Zookeeper. The environment variables required for set-up have already been given values for testing but can be changed in the compose file, the only requirement is to pass in the AWS access key and secret access key in the compose file, along with the target S3 bucket.

- cd to local folder
- Run docker-compose build
- Run docker-compose up -d to start the containers
- Create a producer with bootstr ap-server=localhost:9092 and push data to topic=local-kafka-connect-test-topic
#### Azure Event Hub
If you are integrating with Azure Event Hub and want to run the image locally, you don't need the zookeeper and broker services
in the docker-compose. Alternatively, you can build and run kafka-connect.docker file to start the rest API locally. 
You need to set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. 

In order to check the status of connectors, run docker exec -it <'container-id'> bash in a new terminal window. Then run
curl localhost:8083/connector


### Troubleshooting
Troubleshooting Kafka Connect can be difficult as usually the Kafka error messages are vague. 
You may find information below useful.

#### Connectivity
- Double check the bootstrap url and all the authentication parameters
- Set DEBUG environment variable to true to get the detailed response when sending request to the bootstrap server
- Set CONNECT_LOG4J_LOGGERS="org.apache.kafka.connect=DEBUG" to set kafka-connect log level to debug
- In order to test connection with Kafka broker, you can install telnet by adding it to the docker file. 
You may want to add this command to the start-up.sh to check the connectivity: 
echo -e '\x1dclose\x0d' | telnet <'bootstrap-url'> <'bootstrap-port'>

#### Fargate
- If you are running the image on Fargate, make sure the VPC, Rout Table, Private/Public subnets and Security Group are 
configured correctly. You should have inbound and outbound access to Internet. Preferably assign a specific VPC for Kafka Connect usecase.
- Make sure you have enough memory and CPU, minimum 8GB of memory is recommended. Otherwise, you may get connection refused error. 



### Pushing a new image into ECR
When you are happy with your new image, follow these steps to promote your image into ECR (ensure that you're in the directory with your docker image).

- aws ecr get-login-password --region eu-west-1 | sudo docker login --username AWS --password-stdin <'aws account number'>.dkr.ecr.eu-west-1.amazonaws.com
- sudo docker build -f <'docker file name'>.dockerfile -t <ECR image name> .
- sudo docker tag <'ECR image name'>:latest <'aws account number'>.dkr.ecr.eu-west-1.amazonaws.com/<'ECR image name'>:latest
- sudo docker push <'aws account number'>.dkr.ecr.eu-west-1.amazonaws.com/<ECR image name>:latest
