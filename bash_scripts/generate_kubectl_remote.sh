#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=34.147.88.104

kubectl config set-cluster kubernetes-epo \
    --certificate-authority=files/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

  kubectl config set-credentials admin \
    --client-certificate=files/admin.pem \
    --client-key=files/admin-key.pem

  kubectl config set-context kubernetes-epo \
    --cluster=kubernetes-epo \
    --user=admin

  kubectl config use-context kubernetes-epo


for instance in worker-0 worker-1; do
  gcloud compute instances describe ${instance} \
    --format 'value[separator=" "](networkInterfaces[0].networkIP,metadata.items[0].value)'
done