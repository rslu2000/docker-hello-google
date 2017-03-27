#!/bin/bash

# Exit on any error
set -e

sudo /opt/google-cloud-sdk/bin/gcloud docker -- push us.gcr.io/${PROJECT_NAME}/hello
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
sudo /opt/google-cloud-sdk/bin/gcloud config set account \
circle2google-sa@circle-ctl-test-162119.iam.gserviceaccount.com
sudo /opt/google-cloud-sdk/bin/gcloud container clusters get-credentials  docker-hello-google-cluster \
--zone us-central1-f --project circle-ctl-test-162119
kubectl config set-credentials cluster-admin --client-key=/home/ubuntu/account-auth.json
kubectl run docker-hello-google --image=us.gcr.io/${PROJECT_NAME}/hello --port=3000
#kubectl patch deployment docker-hello-google -p '{"spec":{"template":{"spec":{"containers":[{"name":"docker-hello-google-cluster","image":"us.gcr.io/circle-ctl-test-162119/hello:'"$CIRCLE_SHA1"'"}]}}}}'
kubectl patch deployment docker-hello-google -p '{"spec":{"template":{"spec":{"containers":[{"name":"docker-hello-google","image":"us.gcr.io/circle-ctl-test-162119/hello"}]}}}}'
kubectl expose deployment docker-hello-google --type="LoadBalancer" --port=3000 --target-port=3000
kubectl get services docker-hello-google
kubectl describe services docker-hello-google

