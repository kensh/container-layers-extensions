export ACCOUNTID=$(aws sts get-caller-identity | jq -r .Account)
export REGION=$(aws configure get default.region)
export AWS_ACCESS_KEY_ID=$(aws configure get default.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get default.aws_secret_access_key)

# docker images containermainfunction --no-trunc --format '{{.ID}}' | xargs docker rmi -f

sam build --parameter-overrides \
     ACCOUNTID=${ACCOUNTID} \
     REGION=${REGION} \
     ACCESSKEYID=${AWS_ACCESS_KEY_ID} \
     SECRETACCESSKEY=${AWS_SECRET_ACCESS_KEY}
 