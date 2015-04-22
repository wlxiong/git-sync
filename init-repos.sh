#!/bin/sh -e

REPOS=$1
if [ -z "$REPOS" ]; then
    echo "usage: $0 <repos>"
    exit 1
fi
if [ -e "$REPOS" ]; then
    echo "error: $REPOS exists"
    exit 2
fi

mkdir -p "$REPOS" && cd "$REPOS"
git init
git config core.autocrlf false
