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
    local filehash=$(git hash-object "$file")
    local filehash=${filehash:0:7}
    # if hash tag already exists in filename, skip rename
    if echo "$file" | grep -q "version-$filehash"; then
        echo "Hash tag already exists in filename $file"
        git add "$file"
        return 0
    fi
    local renamed=""
    # create a hash tag and rename file
    if echo "$file" | grep -q '\.'; then
        local extension="${file##*.}"
        local filename="${file%.*}"
        local renamed="$filename.version-$filehash.$extension"
    else
        local renamed="$file.version-$filehash"
    fi
    mv -v "$file" "$renamed"
    git add "$renamed"
    rm -f "$file"
}

cd "$REPOS"
git bundle verify "$DIR/$BUNDLE"
git fetch "$DIR/$BUNDLE" refs/heads/master:refs/remotes/$REMOTE/master
if git merge -v --no-edit refs/remotes/$REMOTE/master; then
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
