#!/bin/sh

TARGET_DIR=certs/$DOMAIN\:$PORT
mkdir -p $TARGET_DIR

openssl req \
    -new \
    -newkey rsa:2048 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=DE/ST=Berlin/L=Berlin/O=gesellix/CN=${DOMAIN} CA" \
    -keyout $TARGET_DIR/ca.key \
    -out $TARGET_DIR/ca.cert

openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -subj "/C=DE/ST=Berlin/L=Berlin/O=gesellix/CN=${DOMAIN}" \
    -keyout $TARGET_DIR/cert.key \
    -out $TARGET_DIR/cert.csr

openssl x509 \
    -req \
    -days 365 \
    -in $TARGET_DIR/cert.csr \
    -CA $TARGET_DIR/ca.cert \
    -CAkey $TARGET_DIR/ca.key \
    -CAcreateserial \
    -out $TARGET_DIR/cert.cert
