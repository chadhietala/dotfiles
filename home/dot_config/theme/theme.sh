#!/bin/bash
# Theme loader — sourced by borders, sketchybar, and its plugins.
# Resolves which theme to use:
#   1. $THEME_NAME env var, if set (ad-hoc override, doesn't persist)
#   2. the persisted choice in ./current (written by switch.sh)
#   3. "rose-pine-moon" as the default
#
# To try a theme without persisting it:  THEME_NAME=tokyo-night ~/.config/theme/apply.sh
# To switch and persist it:              ~/.config/theme/switch.sh tokyo-night

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${THEME_NAME:-}" ] && [ -f "$THEME_DIR/current" ]; then
  THEME_NAME="$(cat "$THEME_DIR/current")"
fi
THEME_NAME="${THEME_NAME:-rose-pine-moon}"

source "$THEME_DIR/themes/$THEME_NAME.sh"
export THEME_NAME
