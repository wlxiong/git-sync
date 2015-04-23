#!/bin/sh -e

git add --all .
if git diff --cached --quiet; then
    echo "*** no changes at $(git show master -s --pretty=format:%h HEAD --abbrev=7)"
    exit 0
fi

TIME="$(date +%s)"
RAND=$(printf "%05d" $RANDOM)
git commit --quiet -m "$TIME-$RAND"
echo "*** commit $(git show master -s --pretty=format:%h HEAD --abbrev=7)"

# Rename detection
# http://stackoverflow.com/questions/14832963/how-can-i-control-the-rename-threshold-when-committing-files-under-git
# git commit never detects renames. It just writes content to the repository.
# Renames (and copies as well) are only detected after the fact, i.e. when
# running git diff, git merge and friends. That's because git does not store
# any rename/copy information.
# 
# So we can ignore output like this:
# [master 534944e] 1429776707-07852
#  6 files changed, 4 insertions(+), 10 deletions(-)
#  rename HostA-1429776679-08990.version-5ddf2b5.txt => HostA-1429776679-08990.txt (75%)
#  delete mode 100644 HostA-1429776679-08990.version-cc1ab7b.txt
#  rename HostB-1429776680-28329.version-77d940b.txt => HostB-1429776680-28329.txt (75%)
#  delete mode 100644 HostB-1429776680-28329.version-9f7b6a4.txt
#  rename HostC-1429776682-08740.version-67003f3.txt => HostC-1429776682-08740.txt (75%)
#  delete mode 100644 HostC-1429776682-08740.version-dca57e8.txt
