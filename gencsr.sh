#!/bin/bash

# Move where we need to be
cd $(dirname $0)

# Make sure we're up to date
git pull || exit 1

# Ensure necessary directories exist
mkdir -p keys requests
chmod 700 keys

if [ -z "$1" ] ; then
    echo "Please run ./gencsr.sh name-of-certificate"
    exit 1
fi

echo "Generating CSR and key for $1"
openssl req -new -out "requests/$1.csr" -keyout "keys/$1.key" -config openssl.cnf -days 365 -rand /dev/random || exit 1

chmod 600 keys/*

echo 'Pushing CSR to remote repo'
(
    git add "requests/$1.csr" && \
    git commit -m "Generated CSR for $1" && \
    git push
) || exit 1

echo 'Proceed to CSR signing on the CA system'

