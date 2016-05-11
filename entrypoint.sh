#!/bin/sh

mkdir -p /host-etc/docker/certs.d/${DOMAIN}:${PORT}
cp /certs/${DOMAIN}:${PORT}/* /host-etc/docker/certs.d/${DOMAIN}:${PORT}

cp /restart-docker.sh /host-etc/periodic/15min/restart-docker
echo "rm /etc/periodic/15min/restart-docker" >> /host-etc/periodic/15min/restart-docker
