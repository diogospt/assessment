#!/bin/bash

gcloud config set project infrastructure-384423
# Provisioning Kubelet Client Certificates

for instance in worker-0 worker-1; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "NL",
      "L": "The Hague",
      "O": "system:nodes",
      "OU": "Kubernetes",
      "ST": "South Holland"
    }
  ]
}
EOF

mv ${instance}-csr.json files/

EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

INTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)')

cfssl gencert \
  -ca=files/ca.pem \
  -ca-key=files/ca-key.pem \
  -config=files/ca-config.json \
  -hostname=${instance},"${EXTERNAL_IP}","${INTERNAL_IP}" \
  -profile=kubernetes \
  files/${instance}-csr.json | cfssljson -bare ${instance}

mv ${instance}-key.pem ${instance}.pem  ${instance}.csr files/
done

