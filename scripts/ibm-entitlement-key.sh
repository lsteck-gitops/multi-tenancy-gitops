#!/usr/bin/env bash

# Set variables
if [[ -z ${TOKEN} ]]; then
  echo "Please provide environment variable TOKEN"
  exit 1
fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml

oc create secret docker-registry ibm-entitlement-key \
--docker-username=cp \
--docker-password=${TOKEN} \
--docker-server=cp.icr.io \
--dry-run=client -o yaml > delete-ibm-entitlement-key-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n tools --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-ibm-entitlement-key-secret.yaml > ibm-entitlement-key-secret.yaml

# NOTE, do not check delete-eum-key-secret.yaml into git!
rm delete-ibm-entitlement-key-secret.yaml




