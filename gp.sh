#!/bin/bash

git rev-parse --is-inside-work-tree > /dev/null 2>&1 || {
    echo "Error: Not inside a Git repository."
    exit 1
}

git pull || {
    echo "Error: Git pull failed."
    exit 1
}

echo "Git pull completed successfully."