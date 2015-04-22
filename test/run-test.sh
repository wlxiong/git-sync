#!/bin/sh -e

DIR="$(dirname $0)"
cd "$DIR"
export PATH="$PWD:$PWD/..:$PATH"

rm -rf *.bundle *.git

update_repos() {
    local REPOS=$1
    pushd "$REPOS"
    new-file.sh
    append-file.sh
    git-commit.sh
    popd
    sleep 1
}

rm -rf HostA.git HostB.git HostC.git
init-repos.sh HostA.git
init-repos.sh HostB.git
init-repos.sh HostC.git

for i in {1..2}; do
    # update HostA
    update_repos HostA.git
    # update HostB
    update_repos HostB.git
    # update HostC
    update_repos HostC.git

    # sync: HostA <- HostB
    sync-repos.sh HostA HostB
    # sync: HostB <- HostA
    sync-repos.sh HostB HostA

    # sync: HostA <- HostC
    sync-repos.sh HostA HostC
    # sync: HostC <- HostA
    sync-repos.sh HostC HostA

    # sync: HostB <- HostC
    sync-repos.sh HostB HostC
    # sync: HostC <- HostB
    sync-repos.sh HostC HostB
done
