#!/bin/bash

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
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

mv service-account-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -profile=kubernetes \
  files/service-account-csr.json | cfssljson -bare service-account

mv service-account.pem service-account.csr service-account-key.pem files/


for instance in worker-0 worker-1; do
  gcloud compute scp files/ca.pem files/${instance}-key.pem files/${instance}.pem ${instance}:~/
done

for instance in master-0 master-1; do
  gcloud compute scp files/ca.pem files/ca-key.pem files/kubernetes-key.pem files/kubernetes.pem \
    files/service-account-key.pem files/service-account.pem ${instance}:~/
done