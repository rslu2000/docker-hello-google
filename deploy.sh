#!/bin/bash

# Exit on any error
set -e

sudo /opt/google-cloud-sdk/bin/gcloud docker -- push us.gcr.io/${PROJECT_NAME}/hello
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
sudo /opt/google-cloud-sdk/bin/gcloud config set account circle2google-sa@circle-ctl-test-162119.iam.gserviceaccount.com
kubectl config set-credentials cluster-admin --client-key=/home/ubuntu/account-auth.json
kubectl patch deployment gke-docker-hello -p '{"spec":{"template":{"spec":{"containers":[{"name":"docker-hello-google-cluster","image":"us.gcr.io/circle-ctl-test-162119/hello:'"$CIRCLE_SHA1"'"}]}}}}'
