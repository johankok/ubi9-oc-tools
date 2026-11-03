#!/bin/sh
set -e

# Download oc client, openshift-install and oc-mirror
CHANNEL="stable-4.22"

# Ask the OpenShift Update Service for the newest release in the channel.
# The mirror's channel directories can lag behind the channel itself.
VERSION="$(curl -fsSL -H 'Accept: application/json' \
  "https://api.openshift.com/api/upgrades_info/v1/graph?channel=$CHANNEL&arch=amd64" \
  | jq -r '.nodes[].version' | sort -V | tail -n 1)"

if [ -z "$VERSION" ]; then
  echo "Could not determine latest version in $CHANNEL" >&2
  exit 1
fi
echo "Latest version in $CHANNEL: $VERSION"

BASE="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/$VERSION"

for file in oc-mirror.tar.gz openshift-client-linux.tar.gz openshift-install-linux.tar.gz sha256sum.txt
do
  curl -f -OL "$BASE/$file"
done

# Verify downloads
sha256sum --check --ignore-missing sha256sum.txt

# Extract oc-mirror
tar zxf oc-mirror.tar.gz && chmod +rx oc-mirror && chown root:root oc-mirror && mv oc-mirror /usr/local/bin/

# Extract oc client
tar zxf openshift-client-linux.tar.gz && mv oc /usr/local/bin/

# Extract openshift-install
tar zxf openshift-install-linux.tar.gz && mv openshift-install /usr/local/bin/
