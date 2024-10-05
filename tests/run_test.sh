#!/usr/bin/env bash

check () {
  local name="$1"
  echo "=== Running test $name ==="
  local tempfile
  tempfile=$(mktemp)
  if [ "$name" != "simple" ]; then
    local tempfile2
    tempfile2=$(mktemp)
  fi
  "./${name}.sh" "$tempfile2" >& "$tempfile"
  echo "Main log check:"
  diff -u <(cat "$tempfile") <(cat "./${name}.log")
  local ret=$?

  if [ "$name" != "simple" ]; then
    echo "File output check:"
    diff -u <(cat "$tempfile2") <(cat "./file_output.log")
    ret=$((ret + $?))
  fi

  if [ "$ret" -eq 0 ]; then
    printf "Test %s passed\n" "$name"
  else
    if test -t 2;then
      printf "\e[31mTest %s failed\e[m\n" "$name"
    else
      printf "Test %s failed\n" "$name"
    fi
  fi
  rm -f "$tempfile" "$tempfile2"
  return $ret
}

ret=0
for name in simple bash zsh;do
  check "$name"
  ret=$((ret + $?))
done
exit $ret
