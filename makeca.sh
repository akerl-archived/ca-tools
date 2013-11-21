#!/bin/bash

# Move us into the right place
cd $(dirname $0)

# Make sure we're up to date
git pull || exit 1

# Don't overwrite an existing setup
if [ -e serial ] ; then
    echo 'CA already exists!'
    exit 1
fi

# Set up needful files
mkdir -p certs crl requests keys
chmod 700 keys
touch index.txt crlnumber
echo "01" > serial
ln -s ./certs/ca.crt ./cacert

echo 'Generating certificate'
openssl req -new -x509 -extensions v3_ca -keyout keys/ca.key -out certs/ca.crt -config openssl.cnf -days 3650 -rand /dev/random

echo 'Pushing CA public cert'
git add .
git commit -m 'Created CA'
git push

echo 'All set'

