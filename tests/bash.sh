#!/usr/bin/env bash
# shellcheck disable=SC1071,SC2034
dir=$(dirname "$0")
if [ $# -gt 0 ]; then
  tmpfile="$1"
else
  tmpfile=$(mktemp)
fi

call_main () {
  # shellcheck disable=SC1091
  source "${dir}/main.sh"
}

echo "######################"
echo "### No file output ###"
echo "######################"
call_main

echo "########################"
echo "### Only file output ###"
echo "########################"
LOGGER_FILE_OUTPUT="$tmpfile"
LOGGER_FILE_ONLY=1
call_main

echo "###################"
echo "### Both output ###"
echo "###################"
LOGGER_FILE_OUTPUT="$tmpfile"
LOGGER_FILE_APPEND=1
LOGGER_FILE_ONLY=0
echo "Both output" >> "$tmpfile"
call_main
