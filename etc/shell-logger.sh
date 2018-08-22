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
LOGGER_DATE_FORMAT=${LOGGER_DATE_FORMAT:-'%Y/%m/%d %H:%M:%S'}
LOGGER_LEVEL=${LOGGER_LEVEL:-1} # 0: debug, 1: info, 2: notice, 3: warning, 4: error
LOGGER_STDERR_LEVEL=${LOGGER_STDERR_LEVEL:-4}
LOGGER_DEBUG_COLOR=${LOGGER_INFO_COLOR:-"3"}
LOGGER_INFO_COLOR=${LOGGER_INFO_COLOR:-""}
LOGGER_NOTICE_COLOR=${LOGGER_INFO_COLOR:-"36"}
LOGGER_WARNING_COLOR=${LOGGER_INFO_COLOR:-"33"}
LOGGER_ERROR_COLOR=${LOGGER_INFO_COLOR:-"31"}
LOGGER_COLOR=${LOGGER_COLOR:-auto}
LOGGER_COLORS=("$LOGGER_DEBUG_COLOR" "$LOGGER_INFO_COLOR" "$LOGGER_NOTICE_COLOR" "$LOGGER_WARNING_COLOR" "$LOGGER_ERROR_COLOR")
if [ "${LOGGER_LEVELS}" = "" ];then
  LOGGER_LEVELS=("DEBUG" "INFO" "NOTICE" "WARNING" "ERROR")
fi
LOGGER_ERROR_RETURN_CODE=${LOGGER_ERROR_RETURN_CODE:-100}
LOGGER_ERROR_TRACE=${LOGGER_ERROR_TRACE:-1} # Only for Bash
# }}}

# Functions {{{
_logger_version () {
  printf "%s %s %s\\n" "$_LOGGER_NAME" "$_LOGGER_VERSION" "$_LOGGER_DATE"
}

_get_level () {
  if [ $# -eq 0 ];then
    local level=1
  else
    local level=$1
  fi
  if ! expr "$level" : '[0-9]*' >/dev/null;then
    [ -z "$ZSH_VERSION" ] || emulate -L ksh
    local i=0
    while [ $i -lt ${#LOGGER_LEVELS[@]} ];do
      if [ "$level" = "${LOGGER_LEVELS[$i]}" ];then
        level=$i
        break
      fi
      ((i++))
    done
  fi
  echo $level
}

_logger_level () {
  if [ $# -eq 1 ];then
    local level=$1
  else
    local level=1
  fi
  [ -z "$ZSH_VERSION" ] || emulate -L ksh
  printf "[${LOGGER_LEVELS[$level]}]"
}

_logger_time () {
  printf "[$(date +"$LOGGER_DATE_FORMAT")]"
}

_logger_file_info () {
  printf "[${BASH_SOURCE[1]}]"
}

_logger () {
  if [ $# -eq 0 ];then
    return
  fi
  local level="$1"
  shift
  if [ "$level" -lt "$(_get_level "$LOGGER_LEVEL")" ];then
    return
  fi
  local msg="$(_logger_time)$(_logger_level "$level") $*"
  local _logger_printf=printf
  local out=1
  if [ "$level" -ge "$LOGGER_STDERR_LEVEL" ];then
    out=2
    _logger_printf=">&2 printf"
  fi
  if [ "$LOGGER_COLOR" = "always" ] || ([ "$LOGGER_COLOR" = "auto" ] && [ -t $out ]);then
    eval "$_logger_printf \"\\e[${LOGGER_COLORS[$level]}m%s\\e[m\\n\"  \"$msg\""
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
info () {
  information "$*"
}

notification () {
  _logger 2 "$*"
}
notice () {
  notification "$*"
}

warning () {
  _logger 3 "$*"
}
warn () {
  warning "$*"
}

error () {
  if [ -z "$ZSH_VERSION" ] && [ "$LOGGER_ERROR_TRACE" -eq 1 ];then
    local first=0
    local current_source=$(echo "${BASH_SOURCE[0]##*/}"|cut -d"." -f1)
    if [ "$current_source" = "shell-logger" ] && [ "${FUNCNAME[1]}" = err ];then
      local first=1
    fi
    echo "Traceback (most recent call last):"
    local i=$((${#BASH_LINENO[@]}-2))
    while [ $i -ge $first ];do
      echo "  File \"${BASH_SOURCE[$((i+1))]}\", line ${BASH_LINENO[$i]}, in ${FUNCNAME[$((i+1))]}"
      if [ $i -gt $first ];then
        echo "    ${FUNCNAME[$i]}()"
      else
        echo ""
      fi
      ((i--))
    done
  fi
  _logger 4 "$*"
  return "$LOGGER_ERROR_RETURN_CODE"
}
err () {
  error "$*"
}
# }}}
