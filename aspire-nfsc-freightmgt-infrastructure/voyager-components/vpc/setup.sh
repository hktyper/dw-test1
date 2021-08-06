apk add --no-cache jq

PYTHONUNBUFFERED=1
apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
python3 -m ensurepip
pip3 install --no-cache --upgrade pip setuptools

TF_STATE_BUCKET=$(cat ./other_vars.json | jq -r '.tf_state_bucket')
TF_STATE_DDB_TABLE=$(cat ./other_vars.json | jq -r '.dynamodb_table')
TF_STATE_KEY=$(cat ./other_vars.json | jq -r '.tf_state_key')
REGION=$(cat ./other_vars.json | jq -r '.region')

terraform init -backend=true \
-backend-config="bucket=$TF_STATE_BUCKET" \
-backend-config="dynamodb_table=$TF_STATE_DDB_TABLE" \
-backend-config="key=$TF_STATE_KEY" \
-backend-config="region=$REGION"

terraform plan -var-file=./tf_vars.json -out=./terraform-dev.plan
terraform validate
terraform apply terraform-dev.plan

python process_output.py

