#!/bin/bash
# JankyBorders has a built-in detection of already running process,
# so it won't be run twice on AeroSpace restart.
source "$HOME/.config/theme/theme.sh"

exec borders \
  active_color="$THEME_BORDER_ACTIVE" \
  inactive_color="$THEME_BORDER_INACTIVE" \
  width="$THEME_BORDER_WIDTH" \
  order=above \
  hidpi=on \
  style=round
