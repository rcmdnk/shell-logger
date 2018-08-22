#!/usr/bin/env bash
dir=$(dirname "$0")
call_main () {
  . "${dir}/main.sh"
}

call_main
