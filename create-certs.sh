#!/bin/sh

TARGET_DIR=certs/$DOMAIN\:$PORT
mkdir -p $TARGET_DIR

#openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}" -keyout ca.key -out ca.crt
#openssl req -new -key host.key -out host.csr
#openssl x509 -req -in host.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out host.crt -days 365

openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}" \
    -keyout $TARGET_DIR/cert.key \
    -out $TARGET_DIR/cert.cert
