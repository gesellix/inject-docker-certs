#!/bin/sh

mkdir -p /vm-etc/docker/certs.d/${DOMAIN}:${PORT}
rm -rf /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/*

cp /certs/${DOMAIN}:${PORT}/cert.cert /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/
cp /certs/${DOMAIN}:${PORT}/cert.key /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/

openssl verify -verbose -CAfile /vm-etc/ssl/certs/ca-certificates.crt /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/cert.cert
CA_CERT_EXISTS=$?
if [ $CA_CERT_EXISTS -ne 0 ]; then
	echo "adding ca.cert to /vm-etc/ssl/certs/ca-certificates.crt"
	cat /certs/${DOMAIN}:${PORT}/ca.cert >> /vm-etc/ssl/certs/ca-certificates.crt
fi

# cp /restart-docker.sh /vm-etc/periodic/15min/restart-docker
# echo "rm /etc/periodic/15min/restart-docker" >> /vm-etc/periodic/15min/restart-docker
