**Inactivity Notice:** I no longer actively use this. It probably still mostly works, but I can't make any promises that the certs it generates make good choices in a modern security env (good hash algo choices, sane openssl settings, etc etc). If you're going to use or borrow from this, I'd recommend making sure you double-check that. If you find an issue, I'd happily accept a GitHub Issue or PR about it.

ca-tools
===========

[![Build Status](https://img.shields.io/circleci/project/akerl/ca-tools.svg)](https://circleci.com/gh/akerl/ca-tools)
[![MIT Licensed](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://tldrlegal.com/license/mit-license)

Certificate authority tools and public bits.

## Usage

### As an end-user

For all the below processes, start by downloading the cert:

```
curl https://github.com/akerl/ca-tools/raw/master/certs/ca.crt
```

#### Mac

1. Open the certificate in Keychain Access:
    * `open ca.crt`
2. Hit "Always Trust"
3. Enter your OSX creds when prompted

#### Thunderbird

1. Open Preferences from the "Thunderbird" menu
2. Navigate to "Advanced", then "Certificates", and click "View Certificates"
3. Click "Import" and select the ca.crt file you downloaded

### As the certificate manager

#### Create a CA (once)

1. Edit openssl.conf to have the right SAN and distinguished_name settings
2. Pick a secure system for the CA to live on
3. If that system is a server, you probably want haveged installed for entropy
4. Clone this repo there
5. Run `makeca.sh`
    * You'll need to provide a passphrase. Put that passphrase in [1Password](https://agilebits.com/onepassword) (you do use 1Password, don't you)

#### Generate a new signed child certificate

Do the following on the system the new certificate is for:

1. If it's a server, install haveged for entropy
2. Clone this repo to the system
3. If you need subject alt names, export the variable now:
    * `export SAN="DNS:othersite.com, DNS:example.com"`
4. Run `gencsr.sh $NAME`, where $NAME is a short name for the certificate

Do the following on the CA system:

1. Run `sign.sh $NAME` using the same name you used previously

Do the following on the system the new certificate is for:

1. Pull the repo changes: `git pull`
2. Your certificate is now located at ./certs/$NAME.crt and the key is in ./keys/$NAME.key

## License

ca-tools is released under the MIT License. See the bundled LICENSE file for details.

