#!/bin/bash

# Generate the Controller Manager client certificate

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv kube-controller-manager-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -profile=kubernetes \
  files/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

mv kube-controller-manager-key.pem kube-controller-manager.pem kube-controller-manager.csr files/