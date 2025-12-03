#!/usr/bin/env bash

set -euo pipefail

cd "${0%/*}/.."

echo "Running rubocop"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$(pwd)/tmp/cache}"
export RUBOCOP_CACHE_ROOT="${RUBOCOP_CACHE_ROOT:-$(pwd)/tmp/rubocop_cache}"
mkdir -p "$RUBOCOP_CACHE_ROOT" "$XDG_CACHE_HOME"
bundle exec rubocop --parallel
