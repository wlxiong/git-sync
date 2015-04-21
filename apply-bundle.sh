#!/bin/sh -e

DIR="$PWD"
REPOS=$1
BUNDLE=$2
if [ -z "$REPOS" -o -z "$BUNDLE" ]; then
    echo "usage: $0 <repos> <bundle file>"
    exit 1
fi
cd "$REPOS"

git bundle verify "$DIR/$BUNDLE"
