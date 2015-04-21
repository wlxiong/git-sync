#!/bin/sh -e

TIME="$(date +%s)"
git add . > /dev/null
git commit -m "$TIME-$RANDOM" > /dev/null
echo "$(git show master -s --pretty=format:%h HEAD --abbrev=7)"
