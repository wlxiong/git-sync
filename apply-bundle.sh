#!/bin/sh -e

DIR="$PWD"
REPOS=$1
REMOTE=$2
BUNDLE=$3
if [ -z "$REPOS" ] || [ -z "$REMOTE" ] || [ -z "$BUNDLE" ]; then
    echo "usage: $0 <repos> <remote> <bundle file>"
    exit 1
fi

rename_file() {
    local file=$1
    local hashtag=$(git hash-object "$file")
    local hashtag=${hashtag:0:7}
    if echo "$file" | grep -q "version-[a-f0-9]\{7\}"; then
        # if hash tag already exists in filename, update it
        echo "Hash tag already exists in filename $file, update if necessary"
        local renamed=$(echo "$file" | sed "s/version-[a-f0-9]\{7\}/version-$hashtag/g")
    elif echo "$file" | grep -q '\.'; then
        # create a hash tag and rename file
        local extension="${file##*.}"
        local filename="${file%.*}"
        local renamed="$filename.version-$hashtag.$extension"
    else
        local renamed="$file.version-$hashtag"
    fi
    [ "$file" != "$renamed" ] && mv -v "$file" "$renamed"
    git add "$renamed"
}

cd "$REPOS"
git bundle verify "$DIR/$BUNDLE"
git fetch "$DIR/$BUNDLE" refs/heads/master:refs/remotes/$REMOTE/master
if git merge -v --no-edit -s recursive -X rename-threshold=100 refs/remotes/$REMOTE/master; then
    exit 0
fi

unmerged=$(git diff --name-only --diff-filter=U)
echo "$unmerged" | while read file; do
    # similar strategies used in git annex, see links:
    # http://git-annex.branchable.com/automatic_conflict_resolution/
    # http://git-annex.branchable.com/design/assistant/blog/day_18__merging/
    echo "Automatically resolving conflict $file"
    git checkout --ours -- "$file"
    rename_file "$file"
    git checkout --theirs -- "$file"
    rename_file "$file"
done
git commit -a --no-edit
