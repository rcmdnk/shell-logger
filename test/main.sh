#!/usr/bin/env bash

source "$(dirname "$0")/../etc/shell-logger"

LOGGER_LEVEL=0
LOGGER_ERROR_TRACE=0
LOGGER_STDERR_LEVEL=4
LOGGER_COLOR=auto
echo "============================================================================="
echo "Followings should be shown:"
echo "    debug, information, info, notification, notice, warning, warn, error, err"
echo "============================================================================="
debug "debug" 2>/dev/null
information "information" 2>/dev/null
info "info" 2>/dev/null
notification "notification" 2>/dev/null
notice "notice" 2>/dev/null
warning "warning" 2>/dev/null
warn "warn" 2>/dev/null
error "error" >/dev/null
err "err" >/dev/null
ret=$?
echo ""
echo "============================================================================="
echo "Error code check: LOGGER_ERROR_RETURN_CODE=$LOGGER_ERROR_RETURN_CODE"
echo "============================================================================="
echo "error return code: $ret"

echo ""
echo "============================================================================="
echo "Test special messages"
echo "============================================================================="
info "\$this message starts with a dollar"

echo ""
echo "============================================================================="
echo "No color test"
echo "============================================================================="
LOGGER_COLOR=never
err "erro: No color test"
LOGGER_COLOR=auto
echo ""
echo "============================================================================="
echo "LOGGER_LEVEL=2 (NOTICE), debug and info should not be shown"
echo "============================================================================="
LOGGER_LEVEL=2
debug "debug: should not be shown"
info "info: should not be shown"
notice "notice: should be shown"
warn "warn: should be shown"
err "err: should be shown"

echo ""
echo "============================================================================="
echo "TRACE BACK test"
echo "============================================================================="
LOGGER_ERROR_TRACE=1

make_error () {
  err "err() is called"
  echo
  error "error() is called"
}

wrapper () {
  make_error
}

main () {
  wrapper
}

main
