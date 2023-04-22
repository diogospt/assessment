#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-public-ip \
  --region europe-west4 \
  --format 'value(address)')

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "Kubernetes",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv kubernetes-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,"${KUBERNETES_PUBLIC_ADDRESS}",127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  files/kubernetes-csr.json | cfssljson -bare kubernetes

mv kubernetes-key.pem kubernetes.pem kubernetes.csr files/