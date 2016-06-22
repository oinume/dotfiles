#!/bin/sh

TARGET=$1
if [ "$TARGET" = "" ]; then
    echo "Argument required. e.g)github.com/oinume/playground-go/"
    exit 1
fi

packages=$(go list ./... | grep -v '/vendor/' | grep -v proto | perl -pe "s!$TARGET!!g")
PACKAGES=$packages

set -x
fswatch -e ".git" -e ".idea" -e "__" -e '\.swp$' -i '.go$' $PACKAGES | xargs -n1 -I{} goimports -w {}
#fswatch -e ".git" -e ".idea" -e "__" -e '\.swp$' -i '.go$' $packages
