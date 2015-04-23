#!/bin/sh -e

DIR="$(dirname $0)"
cd "$DIR"
export PATH="$PWD:$PWD/..:$PATH"

rm -rf *.bundle *.git

update_repos() {
    local HOST=$1
    pushd "$HOST.git"
    new-file.sh "$HOST"
    append-file.sh
    git-commit.sh
    popd
    sleep 1
}

merge_file() {
    local HOST=$1
    pushd "$HOST.git"
    merge-file.sh
    git-commit.sh
    popd
}

rm -rf HostA.git HostB.git HostC.git
init-repos.sh HostA.git
init-repos.sh HostB.git
init-repos.sh HostC.git

for i in {1..2}; do
    update_repos HostA
    update_repos HostB
    update_repos HostC

    # sync: HostA <-> HostB
    sync-repos.sh HostA HostB
    sync-repos.sh HostB HostA
    # sync: HostA <-> HostC
    sync-repos.sh HostA HostC
    sync-repos.sh HostC HostA
    # sync: HostB <-> HostC
    sync-repos.sh HostB HostC
    sync-repos.sh HostC HostB

    merge_file HostA
    merge_file HostB
    merge_file HostC

    # sync: HostA <-> HostB
    sync-repos.sh HostA HostB
    sync-repos.sh HostB HostA
    # sync: HostA <-> HostC
    sync-repos.sh HostA HostC
    sync-repos.sh HostC HostA
    # sync: HostB <-> HostC
    sync-repos.sh HostB HostC
    sync-repos.sh HostC HostB
done
