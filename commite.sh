#!/bin/bash

if [[ $1 != "" ]]; then
    if [[ $1 == "commit" ]]; then
        git add .
        git commit -am "$2"
    elif [[ $1 == "push" ]]; then
        git add .
        git commit -am "$2"; git push
    elif [[ $1 == "pull" ]]; then
        git pull; git rebase
    fi
fi

exit 1