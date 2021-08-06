voyager-components-add:
	echo "==Init git"
	git init
	echo "==Submodule voyager-components"
	git submodule add -b master git@github.com:JSainsburyPLC/voyager-components.git

voyager-components-init:
	echo "==Init git submodule"
	git submodule update --init --recursive
	cd voyager-components;git checkout v1.1.0;cd ..

build:
	echo "==Make config dir"
	mkdir -p configuration/dev/
	echo "==Building Docker image for bootstrap"
	docker build -t voyager-pipeline:local -f ./voyager-components/codepipeline/Dockerfile .

init: voyager-components-add voyager-components-init build


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
		-e PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/terraform/voyager-components/voyager_cli/ \
		-e TF_PLUGIN_CACHE_DIR="/terraform/.cache/plugin-cache" \
		-e LOCAL=true \
		-e AWS_PROFILE \
		-it voyager-pipeline:local /bin/bash -c 'sudo chmod 666 /var/run/docker.sock && \
																						pip3 install -r /terraform/voyager-components/voyager_cli/requirements.txt && \
				
# Start dev container. This is dev is only for Zaid laptop.
zaid_dev:
	@echo "\nRunning dev container"
	@docker run \
		--rm \
		--privileged \
		-v $(shell pwd)/:/terraform \
		-v ${HOME}/.aws:/home/voyager/.aws \
		-v ${HOME}/.ssh:/home/voyager/.ssh \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e HOME=/home/voyager \
		-e PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/terraform/voyager-components/voyager_cli/ \
		-e TF_PLUGIN_CACHE_DIR="/terraform/.cache/plugin-cache" \
		-e LOCAL=true \
		-e AWS_PROFILE \
		-it voyager-pipeline:local /bin/bash -c 'sudo rm /dev/null && \
			                                     sudo mknod /dev/null c 1 3 && \
			                                     sudo chmod 666 /dev/null && \
			                                     sudo chmod 666 /var/run/docker.sock && \
												 pip3.7 install --user -r /terraform/voyager-components/voyager_cli/requirements.txt && \
												 python3.7 /terraform/voyager-components/voyager_cli/voyager dev'

clean:
	rm -rf voyager-components/
	rm -rf .git
	rm -rf configuration/
	rm -rf work-dir/
	rm -rf .cache/
	rm -rf .gitmodules
