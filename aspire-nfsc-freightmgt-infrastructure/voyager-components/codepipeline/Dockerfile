FROM python:3.7

RUN apt-get update && apt-get install -y git openssh-client jq docker.io sudo make libsnappy-dev build-essential libssl-dev libffi-dev python-dev less npm groff zip bc
RUN pip install setuptools
RUN pip install wheel boto3 click pathlib yq pre-commit

ENV TF_VERSION=0.13.5
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && rm terraform_${TF_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin/terraform

ENV TF_LINT=0.24.1
RUN wget https://github.com/terraform-linters/tflint/releases/download/v${TF_LINT}/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && rm tflint_linux_amd64.zip && \
    mv tflint /usr/bin/tflint

ENV AWS_CLI_VERSION=2.0.30
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -O awscli.zip && unzip -q awscli.zip && \
    sudo ./aws/install && rm -rf awscli.zip ./aws/

ENV TERRAGRUNT_VERSION=0.26.7
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O /usr/bin/terragrunt && \
    chmod +x /usr/bin/terragrunt

ENV TFSEC_VERSION=0.37.1
RUN wget https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 -O /usr/bin/tfsec && \
    chmod +x /usr/bin/tfsec

ENV TERRAFORM_DOCS_VERSION=0.10.1
RUN wget https://github.com/terraform-docs/terraform-docs/releases/download/v0.10.1/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 -O /usr/bin/terraform-docs && \
    chmod +x /usr/bin/terraform-docs

ENV ECR_CRED_HELPER_VERSION=0.4.0
RUN wget https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_CRED_HELPER_VERSION}/linux-amd64/docker-credential-ecr-login \
    -O /usr/bin/docker-credential-ecr-login && chmod +x /usr/bin/docker-credential-ecr-login

ENV NODE_MAJOR_VERSION=12
RUN wget -q -O - https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash && \
    sudo apt-get install -y nodejs

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    npm install -g aws-azure-login --unsafe-perm

ENV PACKER_VERSION=1.6.6
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -O packer.zip && \
    unzip -q packer.zip -d /usr/bin/ && \
    chmod +x /usr/bin/packer && rm packer.zip

RUN useradd -m -r -U -G docker voyager && \
    echo "voyager ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /home/voyager/.docker/ && \
    echo '{ "credsStore": "ecr-login" }' >> /home/voyager/.docker/config.json

USER voyager

WORKDIR /terraform
