#!/bin/bash
file=$1
type=$2
out=$(echo "${file%\".\"*}")

if [[ $file == "" ]]; then
    echo "File missing"
    exit 1
fi

if [[ $type == "c" ]]; then
    gcc $file -o $out; ./$out
elif [[ $type == "c++" || $type == "cpp" ]]; then
    g++ $file -o $out; ./$out
elif [[ $type == "py" ]]; then
    python $file
elif [[ $type == "ruby" ]]; then
    ruby $file
elif [[ $type == "bash" || $type == "shell" || $type == "sh" ]]; then
    ./$file
else
    echo "Not a lang: ${type}"
fi