#!/bin/sh 

# Check environment variables
if [ -z "$CA_CN" ]; then
  CA_CN="quicc Certificate Authority"
fi
if [ -z "$CA_ORG" ]; then
  CA_ORG="quicc Community"
fi
if [ -z "$CA_DAYS" ]; then
  CA_DAYS="-1"
fi

if [ ! -f /etc/ocserv/certs/ca-cert.pem ] || [ ! -f /etc/ocserv/certs/ca-key.pem ]; then
mkdir -p /etc/ocserv/certs
cd /etc/ocserv/certs
certtool --generate-privkey --outfile ca-key.pem
cat > ca-tmp.tmpl <<-EOCA
cn = "$CA_CN"
organization = "$CA_ORG"
serial = 1
expiration_days = $CA_DAYS
ca
signing_key
cert_signing_key
crl_signing_key
EOCA
certtool --generate-self-signed --load-privkey ca-key.pem --template ca-tmp.tmpl --outfile ca-cert.pem
rm -rf ca-tmp.tmpl
fi
