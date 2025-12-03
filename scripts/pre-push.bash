#!/usr/bin/env bash

set -euo pipefail

check_changes () {
  echo "Checking git diff from origin/$1..."

  CHANGED_FILES=$(git diff --stat --cached origin/$1)

  if [[ $CHANGED_FILES  == *".rb"* ]] || [[ $CHANGED_FILES  == *".jbuilder"* ]] || [[ $CHANGED_FILES  == *".yml"* ]] || [[ $CHANGED_FILES  == *"Gemfile"* ]]
  then
    echo "Changes to Gemfile, .rb, .jbuilder, or .yml files detected, running checks..."
    ./scripts/run-rubocop.bash || { echo 'Rubocop failed'; exit 1; }
    ./scripts/run-tests.bash || { echo 'Rspec failed'; exit 1; }
  else
    echo "No Gemfile, .rb, .jbuilder, or .yml files were changed, skipping checks"
  fi
}

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE_BRANCH=$(git ls-remote --heads origin $CURRENT_BRANCH)

if [ -z "$REMOTE_BRANCH" ]
  then check_changes "main";
  else check_changes $CURRENT_BRANCH;
fi
