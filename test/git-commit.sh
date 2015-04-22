#!/bin/sh -e

TIME="$(date +%s)"
RAND=$(printf "%05d" $RANDOM)
git add .
git commit -m "$TIME-$RAND"
echo "*** commit $(git show master -s --pretty=format:%h HEAD --abbrev=7)"
