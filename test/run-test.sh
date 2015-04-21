#!/bin/sh -e

DIR="$(dirname $0)"
cd "$DIR"
export PATH="$PWD:$PWD/..:$PATH"

rm -rf *.bundle *.git

init_repos() {
    local REPOS=$1
    rm -rf "$REPOS" && mkdir "$REPOS"
    ( cd "$REPOS" && git init && git config core.autocrlf false)
}

update_repos() {
    local REPOS=$1
    pushd "$REPOS"
    new-file.sh
    append-file.sh
    COMMIT=$(git-commit.sh)
    popd
    sleep 1
}

create_bundle() {
    local REPOS=$1
    local REF=$2
    BUNDLE=$(env HOSTNAME="$REPOS" create-bundle.sh "$REPOS" "$REF")
}

apply_bundle() {
    local REPOS=$1
    local REMOTE=$2
    local BUNDLE=$3
    apply-bundle.sh "$REPOS" "$REMOTE" "$BUNDLE"
}

remote_ref() {
    local REPOS=$1
    local REMOTE=$2
    REMOTE_REF=$(show-remote-ref.sh "$REPOS" "$REMOTE")
}

sync_repos() {
    local LOCAL=$1
    local REMOTE=$2
    # find latest commit of REMOTE in LOCAL.git
    remote_ref "$LOCAL.git" "$REMOTE"
    # export changes: REMOTE host
    create_bundle "$REMOTE.git" "$REMOTE_REF"
    # import changes: LOCAL host <- REMOTE host
    apply_bundle "$LOCAL.git" "$REMOTE" "$BUNDLE"
}

init_repos HostA.git
init_repos HostB.git

for i in {1..2}; do
    # update HostA
    update_repos HostA.git
    # update HostB
    update_repos HostB.git
    # sync: HostA <- HostB
    sync_repos HostA HostB
    # sync: HostB <- HostA
    sync_repos HostB HostA
done
