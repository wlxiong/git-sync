#!/bin/sh -e

TIME="$(date +%s)"
FILES=$(ls)
for file in $FILES; do
    echo "*** append $file"
    echo "$TIME-$RANDOM" >> "$file"
done
