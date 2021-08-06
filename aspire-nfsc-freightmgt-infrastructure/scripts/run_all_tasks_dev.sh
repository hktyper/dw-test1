#!/bin/bash

ENV="dev"
ACCOUNT_NUMBER="302718774358"
SUBNETS='["subnet-0435e5d85c66e7b24","subnet-05cb1f90da0c9c6f9"]'

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
