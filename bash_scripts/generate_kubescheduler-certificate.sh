#!/bin/bash

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv kube-scheduler-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -profile=kubernetes \
  files/kube-scheduler-csr.json | cfssljson -bare kube-scheduler

mv kube-scheduler-key.pem kube-scheduler.pem kube-scheduler.csr files/
