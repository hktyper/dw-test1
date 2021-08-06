build:
	echo "==Building Docker image for bootstrap"
	docker build -t voyager-pipeline:local -f ./codepipeline/Dockerfile .

generate:
	voyager generate --env prod --config-dir .titan/configuration/ --component-dir ./

tfsec:
	./.titan/scripts/code_analysis/terraform.sh

plan:
	voyager deploy --env prod --config-dir .titan/configuration/ --stage plan --component-dir ./
	rm -rf work-dir/

apply:
	voyager deploy --env prod --config-dir .titan/configuration/ --stage apply --component-dir ./
	rm -rf work-dir/

# Start dev container
dev:
	@echo "\nRunning dev container"
	@docker run \
		--rm \
		--privileged \
		-v $(shell pwd)/:/terraform \
		-v ${HOME}/.aws:/home/voyager/.aws \
		-v ${HOME}/.ssh:/home/voyager/.ssh \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e HOME=/home/voyager \
		-e PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/terraform/voyager_cli/ \
		-e TF_PLUGIN_CACHE_DIR="/terraform/.cache/plugin-cache" \
		-e LOCAL=true \
		-e AWS_PROFILE \
		-it voyager-pipeline:local /bin/bash -c 'sudo chmod 666 /var/run/docker.sock && \
																						pip3 install -r /terraform/voyager-components/voyager_cli/requirements.txt && \
																						python /terraform/voyager-components/voyager_cli/voyager dev'

check:
	pre-commit run -a