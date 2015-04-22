#!/bin/sh -e

TIME="$(date +%s)"
FILES=$(ls)
for file in $FILES; do
    RAND=$(printf "%05d" $RANDOM)
    echo "*** append $file"
    echo "$TIME-$RAND" >> "$file"
done
