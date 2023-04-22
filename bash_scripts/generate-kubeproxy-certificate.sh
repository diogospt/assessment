#!/bin/bash

# Generate the KubeProxy certificates

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "system:node-proxier",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv kube-proxy-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -profile=kubernetes \
  files/kube-proxy-csr.json | cfssljson -bare kube-proxy

mv kube-proxy-key.pem kube-proxy.pem kube-proxy.csr files/