#!/bin/sh -e

REPOS=$1
REMOTE=$2
if [ -z "$REPOS" -o -z "$REMOTE" ]; then
    echo "usage: $0 <repos> <remote>"
    exit 1
fi

cd "$REPOS"
echo $(git show-ref --hash --abbrev=7 refs/remotes/$REMOTE/master)
