#!/bin/bash

if [ $# != 1 ]; then
    echo "Wrong usage"
    echo "Syntax: gcmb 'commit message'"
    exit 1
fi

git commit -m "'$(git branch | grep \* | cut -d ' ' -f2)' $1"

exit

# ln -sfTv ~/Git/documentation/scripts/git_commit_branch_prefix.bash ~/bin/gcmb