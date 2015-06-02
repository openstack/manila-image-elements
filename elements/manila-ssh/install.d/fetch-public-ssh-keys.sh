#!/bin/bash

set -x
set -eu
set -o pipefail

MANILA_USER="manila"
MANILA_USER_HOME="/home/$MANILA_USER"
MANILA_USER_SSH_DIR="$MANILA_USER_HOME/.ssh"

if [ ! -d $MANILA_USER_SSH_DIR ]; then
  mkdir -p $MANILA_USER_SSH_DIR
  chmod 700 $MANILA_USER_SSH_DIR
fi

# Fetch public key using HTTP
ATTEMPTS=10
FAILED=0
while [ ! -f $MANILA_USER_SSH_DIR/authorized_keys ]; do
  curl -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /tmp/metadata-key 2>/dev/null
  if [ $? -eq 0 ]; then
    cat /tmp/metadata-key >> $MANILA_USER_SSH_DIR/authorized_keys
    chmod 0600 $MANILA_USER_SSH_DIR/authorized_keys
    rm -f /tmp/metadata-key
    echo "Successfully retrieved public key from instance metadata"
    echo "*****************"
    echo "AUTHORIZED KEYS"
    echo "*****************"
    cat $MANILA_USER_SSH_DIR/authorized_keys
    echo "*****************"
  else
    FAILED=`expr $FAILED + 1`
    if [ $FAILED -ge $ATTEMPTS ]; then
      echo "Failed to retrieve public key from instance metadata after $FAILED attempts, quitting"
      break
    fi
      echo "Could not retrieve public key from instance metadata (attempt #$FAILED/$ATTEMPTS), retrying in 5 seconds..."
      sleep 5
  fi
done

chown -R $MANILA_USER $MANILA_USER_SSH_DIR