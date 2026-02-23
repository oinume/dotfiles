#!/bin/sh

#
# Set up git-wt in git repo
#

git config wt.basedir "../.wt-{gitroot}"


git config --add wt.copy ".env.*"
git config --add wt.copy ".env"
git config --add wt.copy ".envrc"
