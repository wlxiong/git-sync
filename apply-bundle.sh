#!/bin/sh -e

DIR="$PWD"
REPOS=$1
REMOTE=$2
BUNDLE=$3
if [ -z "$REPOS" ] || [ -z "$REMOTE" ] || [ -z "$BUNDLE" ]; then
    echo "usage: $0 <repos> <remote host> <bundle file>"
    exit 1
fi

cd "$REPOS"
git bundle verify "$DIR/$BUNDLE"
git fetch "$DIR/$BUNDLE" refs/heads/master:refs/remotes/$REMOTE/master
if git merge refs/remotes/$REMOTE/master; then
    exit 0
fi

