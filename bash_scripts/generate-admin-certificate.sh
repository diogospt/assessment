#!/bin/bash

# Provisioning Client and Server Certificates

# Admin Client Certificate

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "system:masters",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv admin-csr.json files/

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -profile=kubernetes \
  files/admin-csr.json | cfssljson -bare admin

mv admin-key.pem admin.pem admin.csr files/


