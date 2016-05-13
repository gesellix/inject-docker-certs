#!/bin/sh

mkdir -p /host-etc/docker/certs.d/${DOMAIN}:${PORT}
rm -rf /host-etc/docker/certs.d/${DOMAIN}:${PORT}/*

cp /certs/${DOMAIN}:${PORT}/cert.cert /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/
cp /certs/${DOMAIN}:${PORT}/cert.key /vm-etc/docker/certs.d/${DOMAIN}:${PORT}/
cat /certs/${DOMAIN}:${PORT}/ca.cert >> /vm-etc/ssl/certs/ca-certificates.crt

# cp /restart-docker.sh /vm-etc/periodic/15min/restart-docker
# echo "rm /etc/periodic/15min/restart-docker" >> /vm-etc/periodic/15min/restart-docker
