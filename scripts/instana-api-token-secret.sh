#!/usr/bin/env bash

# Set variables
if [[ -z ${API_TOKEN} ]]; then
  echo "Please provide environment variable API_TOKEN"
  exit 1
fi

# Set variables
if [[ -z ${INSTANA_URL} ]]; then
  echo "Please provide environment variable INSTANA_URL"
  exit 1
fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml

oc create secret generic instana-backend \
--from-literal=API_TOKEN=${API_TOKEN} \
--from-literal=INSTANA_URL=${INSTANA_URL} \
--dry-run=client -o yaml > delete-instana-api-token-secret.yaml


# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n tools --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-instana-api-token-secret.yaml > instana-api-token-secret.yaml

# NOTE, do not check delete-api-token-secret.yaml into git!
rm delete-instana-api-token-secret.yaml
