FROM public.ecr.aws/lambda/python:3.8 as layer-copy 

ARG AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-""}
ARG AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-"ap-northeast-1"}
ARG AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-""}
ARG AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-""}
ARG LAYER1=${LAYER1:-""}
ARG LAYER2=${LAYER2:-""}

RUN yum -y install \
    curl \
    unzip \
    jq \
    aws-cli


RUN mkdir -p /opt

### PythonExtensionLayer
ARG LAYER_NAME=${LAYER1}
RUN VERSION=$(aws lambda list-layer-versions --layer-name ${LAYER_NAME} | jq '[.LayerVersions[].Version] | max'); \
    curl $(aws lambda get-layer-version-by-arn --arn arn:aws:lambda:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:layer:${LAYER_NAME}:${VERSION} --query 'Content.Location' --output text) --output layer.zip
RUN unzip layer.zip -d /opt
RUN rm layer.zip

### PythonLibLayer
ARG LAYER_NAME=${LAYER2}
RUN VERSION=$(aws lambda list-layer-versions --layer-name ${LAYER_NAME} | jq '[.LayerVersions[].Version] | max'); \
    curl $(aws lambda get-layer-version-by-arn --arn arn:aws:lambda:${AWS_DEFAULT_REGION}:${AWS_ACCOUNT_ID}:layer:${LAYER_NAME}:${VERSION} --query 'Content.Location' --output text) --output layer.zip
RUN unzip layer.zip -d /opt
RUN rm layer.zip


# Start second stage from blank image to squash all previous history, including credentials.
FROM public.ecr.aws/lambda/python:3.8
WORKDIR /opt
COPY --from=layer-copy /opt .


WORKDIR /var/task
COPY app.py requirements.txt ./
RUN python3.8 -m pip install -r requirements.txt -t .

# Command can be overwritten by providing a different command in the template directly.
CMD ["app.lambda_handler"]
