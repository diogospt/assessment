#!/bin/bash
# Provisioning a CA and Generating TLS Certificates
## Certificate Authority
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

mv ca-config.json files/

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "South Holland"
    }
  ]
}
EOF

mv ca-csr.json files/

cfssl gencert -initca files/ca-csr.json | cfssljson -bare ca

mv ca.csr files/
mv ca.pem files/
mv ca-key.pem files/