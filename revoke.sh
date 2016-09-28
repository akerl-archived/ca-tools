#!/bin/bash

# Move where we need to be
cd "$(dirname $0)"

# Make sure repo is up to date
git pull || exit 1

# Make sure the cert exists
if [ -z "$1" -o ! -f "certs/$1.crt" ] ; then
    echo 'Please run ./revoke.sh name-of-cert'
    exit 1
fi

echo 'Revoking the certificate'
openssl ca -config openssl.cnf -verbose -revoke "certs/$1.crt" || exit 1

echo 'Pushing the update to the remote repo'
(
    git add . && \
    git commit -am "Revoke $1" && \
    git push
) || exit 1

echo 'The CSR has been revoked'

