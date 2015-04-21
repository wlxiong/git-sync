#!/bin/sh -e

DIR="$PWD"
REPOS=$1
FROM_REF=$2
if [ -z "$REPOS" ]; then
    echo "usage: $0 <repos> [base ref]"
    exit 1
fi
cd "$REPOS"

HEAD_HASH=$(git show master -s --pretty=format:%h HEAD --abbrev=7)
if [ -n "$FROM_REF" ]; then
    BUNDLE="$HOSTNAME-$FROM_REF-$HEAD_HASH.bundle"
    git bundle create "$DIR/$BUNDLE" $FROM_REF..$HEAD_HASH --branches --tags > /dev/null
else
    BUNDLE="$HOSTNAME-0000000-$HEAD_HASH.bundle"
    git bundle create "$DIR/$BUNDLE" $HEAD_HASH --branches --tags > /dev/null
fi
echo "$BUNDLE"
