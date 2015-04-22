#!/bin/sh -e

TIME="$(date +%s)"
files=$(ls)
for file in $files; do
    if echo "$file" | grep -qv "version"; then
        echo "*** append $file"
        echo "$TIME-$RANDOM" >> "$file"
    fi
done
