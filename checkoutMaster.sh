#!/usr/bin/env bash

set -euo pipefail

BRANCH="master"

# Ensure this is a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not inside a Git repository."
    exit 1
fi

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: You have uncommitted changes."
    echo "Commit or stash them before switching branches."
    exit 1
fi

# Check whether the branch exists
if ! git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "Error: Local branch '$BRANCH' does not exist."
    exit 1
fi

echo "Switching to '$BRANCH'..."

git checkout "$BRANCH"

echo "Successfully switched to '$BRANCH'."