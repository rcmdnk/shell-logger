#!/usr/bin/env bash

## Description {{{
#
# Logger for shell script.
#
# Homepage: https://github.com/rcmdnk/shell-logger
#
_LOGGER_NAME="shell-logger"
_LOGGER_VERSION="v0.1.0"
_LOGGER_DATE="22/Aug/2018"
# }}}

## License {{{
#
#MIT License
#
#Copyright (c) 2017 rcmdnk
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
# }}}

# Default variables {{{
_LOGGER_DATE_FORMAT=${_LOGGER_DATE_FORMAT:-'%Y/%m/%d %H:%M:%S'}
_LOGGER_LEVEL=${_LOGGER_LEVEL:-1} # 0: debug, 1: info, 2: notice, 3: warning, 4: error
_LOGGER_STDERR_LEVEL=${_LOGGER_STDERR_LEVEL:-4}
_LOGGER_DEBUG_COLOR=${_LOGGER_INFO_COLOR:-"3"}
_LOGGER_INFO_COLOR=${_LOGGER_INFO_COLOR:-""}
_LOGGER_NOTICE_COLOR=${_LOGGER_INFO_COLOR:-"36"}
_LOGGER_WARNING_COLOR=${_LOGGER_INFO_COLOR:-"33"}
_LOGGER_ERROR_COLOR=${_LOGGER_INFO_COLOR:-"31"}
_LOGGER_COLOR=${_LOGGER_COLOR:-auto}
_LOGGER_COLORS=("$_LOGGER_DEBUG_COLOR" "$_LOGGER_INFO_COLOR" "$_LOGGER_NOTICE_COLOR" "$_LOGGER_WARNING_COLOR" "$_LOGGER_ERROR_COLOR")
if [ "${_LOGGER_LEVELS}" = "" ];then
  _LOGGER_LEVELS=("DEBUG" "INFO" "NOTICE" "WARNING" "ERROR")
fi
# }}}

# Functions {{{
_logger_version () {
  printf "%s %s %s\\n" "$_LOGGER_NAME" "$_LOGGER_VERSION" "$_LOGGER_DATE"
}

_logger_level () {
  local level=$1
  shift
  [ -z "$ZSH_VERSION" ] || emulate -L ksh
  printf "[${_LOGGER_LEVELS[$level]}] $*"
}

_logger_time () {
  printf "[$(date +"$_LOGGER_DATE_FORMAT")] $*"
}


_get_logger_level () {
  if expr "$_LOGGER_LEVEL" : '[0-9]*' >/dev/null;then
    echo "$_LOGGER_LEVEL"
  else
    local logger_level=0
    local n=0
    for l in "${_LOGGER_LEVELS[@]}";do
      if [ "$_LOGGER_LEVEL" = "$l" ];then
        logger_level=$n
        break
      fi
      ((n++))
    done
    echo $logger_level
  fi
}

_logger () {
  if [ $# -eq 0 ];then
    return
  fi
  local level="$1"
  shift
  if [ "$level" -lt "$(_get_logger_level "$_LOGGER_LEVEL")" ];then
    return
  fi
  local msg=$(_logger_time "$(_logger_level "$level" "$*")")
  local _logger_printf=printf
  local out=1
  if [ "$level" -ge "$_LOGGER_STDERR_LEVEL" ];then
    out=2
    _logger_printf=">&2 printf"
  fi
  if [ "$_LOGGER_COLOR" = "always" ] || ([ "$_LOGGER_COLOR" = "auto" ] && [ -t $out ]);then
    eval "$_logger_printf \"\\e[${_LOGGER_COLORS[$level]}m%s\\e[m\\n\"  \"$msg\""
  else
    eval "$_logger_printf \"%s\\n\" \"$msg\""
  fi
}

debug () {
  _logger 0 "$*"
}

information () {
  _logger 1 "$*"
}
alias info=information

notification () {
  _logger 2 "$*"
}
alias notice=notification

warning () {
  _logger 3 "$*"
}
alias warn=warning

error () {
  _logger 4 "$*"
  return 100
}
alias err=error
# }}}
