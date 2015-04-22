#!/bin/sh -e

TIME="$(date +%s)"
RAND=$(printf "%05d" $RANDOM)
FILE="$TIME-$RAND.txt"
echo "*** create $FILE"
echo "$TIME-$RAND" > "$FILE"
