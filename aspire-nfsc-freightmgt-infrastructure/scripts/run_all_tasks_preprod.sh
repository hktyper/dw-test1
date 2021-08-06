#!/bin/bash

ENV="preprod"
ACCOUNT_NUMBER="302718774358"
SUBNETS='["subnet-05b5d5c8f1c5f5929","subnet-0b40b985a8c868305"]'

run_task() {
	aws ecs run-task --cluster aspire-nfsc-freightmgt-$1-ecs-cluster \
	                 --launch-type FARGATE  \
	                 --task-definition arn:aws:ecs:eu-west-1:$2:task-definition/$3-$1-task \
	                 --network-configuration "awsvpcConfiguration={subnets=$4,assignPublicIp="DISABLED"}" \
	                 --no-cli-pager
}

run_task $ENV $ACCOUNT_NUMBER "orderlines" $SUBNETS
run_task $ENV $ACCOUNT_NUMBER "containers" $SUBNETS
run_task $ENV $ACCOUNT_NUMBER "allocations" $SUBNETS
run_task $ENV $ACCOUNT_NUMBER "exceptions" $SUBNETS
run_task $ENV $ACCOUNT_NUMBER "shipments" $SUBNETS
