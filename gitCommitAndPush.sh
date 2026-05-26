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

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ -z "$CURRENT_BRANCH" ]; then
  echo "Unable to detect current branch"
  exit 1
fi

if [ "$CURRENT_BRANCH" = "master" ]; then
  echo "Direct push to master is not allowed"
  exit 1
fi

git add --all

if git diff --cached --quiet; then
  echo "No changes to commit"
  exit 0
fi

git commit -m "$COMMIT_MESSAGE"

git push -u origin "$CURRENT_BRANCH"

echo "Code pushed successfully to $CURRENT_BRANCH"