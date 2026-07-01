#!/bin/sh
set -e

# Download oc client, openshift-install and oc-mirror
VERSION="stable-4.21"
BASE="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/$VERSION"

for file in oc-mirror.tar.gz openshift-client-linux.tar.gz openshift-install-linux.tar.gz sha256sum.txt
do
  curl -f -OL $BASE/$file
done

# Verify downloads
sha256sum --check --ignore-missing sha256sum.txt

# Extract oc-mirror
tar zxf oc-mirror.tar.gz && chmod +rx oc-mirror && chown root:root oc-mirror && mv oc-mirror /usr/local/bin/

# Extract oc client
tar zxf openshift-client-linux.tar.gz && mv oc /usr/local/bin/

# Extract openshift-install
tar zxf openshift-install-linux.tar.gz && mv openshift-install /usr/local/bin/
