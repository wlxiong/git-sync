#!/bin/sh -e

FILES=$(ls)
for file in $FILES; do
    if echo "$file" | grep -q ".version-[a-f0-9]\{7\}"; then
        prefix=$(echo "$file" | sed "s/.version-[a-f0-9]\{7\}.*//g")
        noversion=$(echo "$file" | sed "s/.version-[a-f0-9]\{7\}//g")
        echo "*** merge $noversion"
        cat $prefix* | sort | uniq > "$noversion"
        ls -1 $prefix* | grep -v "$noversion" | xargs rm -f
    fi
done
