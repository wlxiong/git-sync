#!/bin/sh -e

HOST=${1:-UNKNOWNHOST}
TIME="$(date +%s)"
RAND=$(printf "%05d" $RANDOM)
FILE="$HOST-$TIME-$RAND.txt"
echo "*** create $FILE"
echo "$TIME-$RAND" > "$FILE"
