#!/bin/bash
dirs=$(find . -type f -name '*.rego' -exec dirname {} \; | sort -u)
echo "Directories to be tested:"
for dir in $dirs; do 
    echo "$dir"
done
for dir in $dirs; do 
    echo "Running tests in $dir"
    if ! opa test $dir/ -v --format pretty; then
        echo "Tests failed in $dir"
        exit 1
    fi
done