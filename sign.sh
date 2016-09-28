#!/bin/bash

# Move where we need to be
cd "$(dirname $0)"

# Make sure repo is up to date
git pull || exit 1

# Make sure the CSR exists
if [ -z "$1" -o ! -f "requests/$1.csr" ] ; then
    echo 'Please run ./sign.sh name-of-system'
    exit 1
fi

echo 'Signing the certificate'
openssl ca -config openssl.cnf -in "requests/$1.csr" -verbose -out "certs/$1.crt" || exit 1

echo 'Pushing the certificate to the remote repo'
(
    git add "certs/$1.crt" && \
    git commit -am "Signed request for $1" && \
    git push
) || exit 1

echo 'The CSR has been signed'

