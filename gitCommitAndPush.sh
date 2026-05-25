#!/bin/bash

set -e

COMMIT_MESSAGE="$1"

if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Commit message is required"
  exit 1
fi

if [ ! -d ".git" ]; then
  echo "Not a git repository"
  exit 1
fi

read -p "Did you disable isStaging=false / comment one_time_service? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
  echo "Aborted"
  exit 1
fi

CURRENT_BRANCH=$(git branch --show-current)

git add --all

if git diff --cached --quiet; then
  echo "No changes to commit"
  exit 0
fi

git commit -m "$COMMIT_MESSAGE"

git push -u origin "$CURRENT_BRANCH"