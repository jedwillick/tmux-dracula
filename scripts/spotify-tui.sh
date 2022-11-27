#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

# https://stackoverflow.com/a/3352015
trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)

  if ! command -v spt &> /dev/null; then
    exit 1
  fi

  raw=$(spt playback --format "%s %t;%a")

  [ -z "$raw" ] && return

  title=$(trim "$(echo "$raw" | cut -d';' -f1 | cut -d'-' -f1)")
  artist=$(trim "$(echo "$raw" | cut -d';' -f2 | cut -d',' -f1)")
  full="$title - $artist"
  echo "${full}"
}

# run the main driver
main
