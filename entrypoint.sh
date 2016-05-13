#!/bin/sh

mkdir -p /host-etc/docker/certs.d/${DOMAIN}:${PORT}
rm -rf /host-etc/docker/certs.d/${DOMAIN}:${PORT}/*

cp /certs/${DOMAIN}:${PORT}/cert.cert /host-etc/docker/certs.d/${DOMAIN}:${PORT}/
cp /certs/${DOMAIN}:${PORT}/cert.key /host-etc/docker/certs.d/${DOMAIN}:${PORT}/
cat /certs/${DOMAIN}:${PORT}/ca.cert >> /host-etc/ssl/certs/ca-certificates.crt

# cp /restart-docker.sh /host-etc/periodic/15min/restart-docker
# echo "rm /etc/periodic/15min/restart-docker" >> /host-etc/periodic/15min/restart-docker
