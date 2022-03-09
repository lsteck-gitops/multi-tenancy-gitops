#!/usr/bin/env bash

# Set variables
if [[ -z ${EUM_KEY} ]]; then
  echo "Please provide environment variable EUM_KEY"
  exit 1
fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml

oc create secret generic instana-eum-key \
--from-literal=key=${EUM_KEY} \
--dry-run=client -o yaml > delete-instana-eum-key-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n robot-shop --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-instana-eum-key-secret.yaml > instana-eum-key-secret.yaml

# NOTE, do not check delete-eum-key-secret.yaml into git!
rm delete-instana-eum-key-secret.yaml




