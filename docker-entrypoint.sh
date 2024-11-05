#!/bin/sh

# Abort on any error (including if wait-for-it fails).
set -e

# Wait for the MySQL backend to be up

# If both database connection host and port are set
if [ -n "$database__connection__host" ] && [ -n "$database__connection__port" ]; then
    ./wait-for-it.sh "$database__connection__host:$database__connection__port" --strict --timeout=300
fi
# If only database connection host is set
if [ -n "$database__connection__host" ] && [ -z "$database__connection__port" ]; then
    ./wait-for-it.sh "$database__connection__host" --strict --timeout=300
fi

# Run the main container command
exec "$@"