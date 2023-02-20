#!/usr/bin/env bash

CERT_DIR=/var/azuracast/acme
SELF_SIGNED_KEY=$CERT_DIR/default.key
SELF_SIGNED_CERT=$CERT_DIR/default.crt

# Create the certificates directory if it does not exist
mkdir -p $CERT_DIR

# Generate a self-signed certificate if it does not exist
if [ ! -f $SELF_SIGNED_CERT ]; then
    openssl req -new -nodes -x509 -subj "/C=US/ST=Texas/L=Austin/O=IT/CN=localhost" \
        -days 365 -extensions v3_ca \
        -keyout $SELF_SIGNED_KEY \
        -out $SELF_SIGNED_CERT
fi

# Create symbolic links for the self-signed certificate and key
ln -sf $SELF_SIGNED_KEY $CERT_DIR/ssl.key
ln -sf $SELF_SIGNED_CERT $CERT_DIR/ssl.crt

# Set appropriate ownership and permissions for the certificate directory
chown -R azuracast:azuracast $CERT_DIR
chmod -R u=rwX,go=rX $CERT_DIR
