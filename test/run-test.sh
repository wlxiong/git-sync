#!/bin/sh -ex

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
}

merge_file() {
    local HOST=$1
    pushd "$HOST.git"
    merge-file.sh
    git-commit.sh
    popd
}

do_sync() {
    local HOSTS="$1"
    local ALL=$2
    for host0 in $HOSTS; do
        for host1 in $HOSTS; do
            if [ "$host0" = "$host1" ]; then
                continue
            fi
            if [ $ALL -eq 1 -o $(($RANDOM % 2)) -eq 1 ]; then
                sync-repos.sh $host0 $host1
            fi
            if [ $ALL -eq 1 -o $(($RANDOM % 2)) -eq 1 ]; then
                sync-repos.sh $host1 $host0
            fi
        done
    done
}

check_sync() {
    local HOSTS="$1"
    for host0 in $HOSTS; do
        for host1 in $HOSTS; do
            if [ "$host0" = "$host1" ]; then
                continue
            fi
            diff -r --exclude=".git" "$host0.git" "$host1.git"
        done
    done
}

rm -rf HostA.git HostB.git HostC.git
init-repos.sh HostA.git
init-repos.sh HostB.git
init-repos.sh HostC.git

for i in {1..5}; do
    update_repos HostA
    update_repos HostB
    update_repos HostC

    do_sync "HostA HostB HostC" 0

    merge_file HostA
    merge_file HostB
    merge_file HostC

    do_sync "HostC HostA HostC" 0
done

do_sync "HostC HostB HostA" 1
check_sync "HostC HostB HostA"
