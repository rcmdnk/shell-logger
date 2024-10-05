#!/usr/bin/env zsh
# shellcheck disable=SC1071
dir=$(dirname "$0")
if [ $# -gt 0 ]; then
  tmpfile="$1"
else
  tmpfile=$(mktemp)
fi

source "${dir}/bash.sh" "$tmpfile"
