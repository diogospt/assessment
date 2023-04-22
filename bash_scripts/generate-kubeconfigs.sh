#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-public-ip \
  --region europe-west4 \
  --format 'value(address)')

for instance in worker-0 worker-1; do
  kubectl config set-cluster kubernetes-epo \
    --certificate-authority=files/ca.pem \
    --embed-certs=true \
    --server=https://"${KUBERNETES_PUBLIC_ADDRESS}":6443 \
    --kubeconfig=files/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=files/${instance}.pem \
    --client-key=files/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=files/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-epo \
    --user=system:node:${instance} \
    --kubeconfig=files/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=files/${instance}.kubeconfig
done

# ----

kubectl config set-cluster kubernetes-epo \
  --certificate-authority=files/ca.pem \
  --embed-certs=true \
  --server=https://"${KUBERNETES_PUBLIC_ADDRESS}":6443 \
  --kubeconfig=files/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=files/kube-proxy.pem \
  --client-key=files/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=files/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-epo \
  --user=system:kube-proxy \
  --kubeconfig=files/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=files/kube-proxy.kubeconfig

# ---

kubectl config set-cluster kubernetes-epo \
  --certificate-authority=files/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=files/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=files/kube-controller-manager.pem \
  --client-key=files/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=files/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-epo \
  --user=system:kube-controller-manager \
  --kubeconfig=files/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=files/kube-controller-manager.kubeconfig

# ---

kubectl config set-cluster kubernetes-epo \
  --certificate-authority=files/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=files/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=files/kube-scheduler.pem \
  --client-key=files/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=files/kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-epo \
  --user=system:kube-scheduler \
  --kubeconfig=files/kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=files/kube-scheduler.kubeconfig

# ---

kubectl config set-cluster kubernetes-epo \
  --certificate-authority=files/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=files/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=files/admin.pem \
  --client-key=files/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=files/admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-epo \
  --user=admin \
  --kubeconfig=files/admin.kubeconfig

kubectl config use-context default --kubeconfig=files/admin.kubeconfig


for instance in worker-0 worker-1; do
  gcloud compute scp files/${instance}.kubeconfig files/kube-proxy.kubeconfig ${instance}:~/
done

for instance in master-0 master-1; do
  gcloud compute scp files/admin.kubeconfig files/kube-controller-manager.kubeconfig files/kube-scheduler.kubeconfig ${instance}:~/
done