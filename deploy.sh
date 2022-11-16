#!/bin/bash
export NAMESPACE=test
export API_VERSION=v1
export APPNAME=validation
export NAME=${APPNAME}-${API_VERSION}
export PORT=80

export IMAGE_SERVER=harbor.metaage.tech/test/validation
export VERSION=1.0
export IMAGE=$IMAGE_SERVER:$VERSION

mvn clean package spring-boot:repackage

docker rmi $IMAGE
docker build -t $IMAGE .
docker push $IMAGE

envsubst < template.yaml > deploy.yaml

kubectl apply -f deploy.yaml

\rm deploy.yaml