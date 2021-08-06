#!/bin/bash

ENV="prod"
ACCOUNT_NUMBER="141651631005"
SUBNETS='["subnet-042626dd0cfddffe7","subnet-03c99667d37b9b676"]'

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
