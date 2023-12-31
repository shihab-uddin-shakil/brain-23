#!/bin/bash
set -ex

PROJECT_ROOT=/home/shihab/Documents/jenkins-workspace/brain-23-app1/task1/app1

#scan code
sonar-scanner \
  -Dsonar.projectKey=app1 \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_238819299122d7d76f0fd912b18a67cf91d8b117
  
# Build docker app1 image
cd $PROJECT_ROOT
docker build . -t app1 -f ./build/Dockerfile

# Create docker image random tag number
IMAGE_TAG=$((1 + RANDOM % 1000))

#scan image
trivy image app1


#tag docker image
docker tag app1  shihab24/app1:$IMAGE_TAG

#tag docker image
docker push shihab24/app1:$IMAGE_TAG

#update k8s image tag

sed "s|{{IMAGE_TAG}}|${IMAGE_TAG}|g" ./deploy/template/deployment.yml.temp  >  ./deploy/deployment.yml
