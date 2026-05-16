#!/bin/bash

set -e

COMMIT_MESSAGE="$1"

if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Commit message is required"
  exit 1
fi

git add --all

git diff --cached --quiet && {
  echo "No changes to commit"
  exit 0
}

git commit -m "$COMMIT_MESSAGE"

git push