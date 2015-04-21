#!/bin/sh -e

DIR="$(dirname $0)"
cd "$DIR"
export PATH="$PWD:$PWD/..:$PATH"

rm -rf *.bundle *.git

init_repos() {
    local REPOS=$1
    rm -rf "$REPOS" && mkdir "$REPOS"
    ( cd "$REPOS" && git init )
}

update_and_bundle() {
    local REPOS=$1
    local REF=$2
    pushd "$REPOS"
    new-file.sh
    append-file.sh
    COMMIT=$(git-commit.sh)
    popd
    BUNDLE=$(env HOSTNAME="$REPOS" create-bundle.sh "$REPOS" "$REF")
    echo $COMMIT $BUNDLE
}

init_repos HostA.git
init_repos HostB.git

update_and_bundle HostA.git
update_and_bundle HostB.git
