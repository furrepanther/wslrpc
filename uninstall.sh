#!/bin/sh
set -eu

PROFILE_FILE=/etc/profile.d/wslrpc.sh
if [ -f "$PROFILE_FILE" ]; then
    rm -f "$PROFILE_FILE"
    echo "removed $PROFILE_FILE"
else
    echo "$PROFILE_FILE is already absent"
fi
