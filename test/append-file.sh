#!/bin/sh -e

TIME="$(date +%s)"
for file in *; do
    echo "$TIME-$RANDOM" >> "$file"
done
