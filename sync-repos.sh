#!/bin/sh -e

DIR="$(dirname $0)"
pushd "$DIR"
export PATH="$PWD:$PATH"
popd

LOCAL=$1
REMOTE=$2

if [ -z "$LOCAL" -o -z "$REMOTE" ]; then
    echo "usage: $0 <repos> <remote>"
    exit 1
fi

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

# find latest commit of REMOTE in LOCAL.git
echo "Syncing $LOCAL <- $REMOTE"
remote_ref "$LOCAL.git" "$REMOTE"
echo "Latest commit of $REMOTE at $LOCAL: ${REMOTE_REF:-(none)}"
# export changes: REMOTE host
echo "Creating bundle at $REMOTE based on ${REMOTE_REF:-(none)}"
create_bundle "$REMOTE.git" "$REMOTE_REF"
# import changes: LOCAL host <- REMOTE host
echo "Applying bundle $BUNDLE at $LOCAL"
apply_bundle "$LOCAL.git" "$REMOTE" "$BUNDLE"
