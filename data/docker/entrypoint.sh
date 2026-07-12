#!/bin/bash
set -e

cleanup() {
    kill -- -$$ 2>/dev/null
    exit 0
}
trap cleanup SIGTERM SIGINT

mkdir -p /var/run/samba /run/samba

/slapd.sh

smbd --daemon --no-process-group
nmbd --daemon --no-process-group

sleep infinity &
wait $!
