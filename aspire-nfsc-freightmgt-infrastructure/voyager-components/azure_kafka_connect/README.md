# Azure Kafka Connect Component

This component contains the configuration required to deploy a VPC and a Fargate ECS Cluster with the Kafka Connect Azure Image

## Pre-requisites:

Ensure your account has connectivity to the Confluent Endpoint and have the necessary SSL/SASL credentials and certificates to connect.  
More information on how this is done and configured: https://sainsburys-confluence.valiantys.net/display/LIME/Kafka+Connect+Configuration

Ensure that you have an accessible docker image available in the AWS Account (The example below assumes ECR) to build the Kafka Connect Tasks and Services  
See docker directory for image and README.md for instructions on how to build and upload the docker image to ECR

Ensure that any KMS secrets that the ECS cluster needs to access is created ahead of deploying the component and ensure that secret\_names is populated with the correct names

Ensure that any S3 buckets that are required are created before deploying the component and populated in both your container environment variables and s3\_bucket\_names

Ensure that your templates for your tasks are populated and have the full directory path to the template in the ecs\_tasks container\_definition variable.

## Known Issues

https://github.com/JSainsburyPLC/voyager-components/labels/azure_kafka_connect

## Component Requirements~~~~

The following components this module requires.

| Name | Reason | Required outputs provided |
|------|--------|---------------------------|
| vpc | To provide necessary networking setup | Yes |
| fargate\_ecs | To build out the ECS cluster to host the Kafka Connect Services (See readme.md in that component)| N/A

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

No input.

#### Outputs

No output.

