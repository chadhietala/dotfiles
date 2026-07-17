#!/bin/bash
source "$HOME/.config/theme/theme.sh"

# $1 is the workspace id this badge represents (passed in from sketchybarrc).
# $FOCUSED_WORKSPACE is supplied by the aerospace_workspace_change trigger.
#
# Only a window of WINDOW_SIZE badges is fully shown at once, centered on the
# focused workspace (clamped at both ends of the 1..TOTAL range). One badge
# on each side of the window "peeks" in at reduced size/opacity to hint that
# more workspaces exist; everything further out is fully collapsed. This
# keeps the bar from stretching all the way across when workspaces climb
# toward 9.

WINDOW_SIZE=5
TOTAL=9
PEEK_COLOR="0x40${THEME_MUTED#0xff}"

active="$FOCUSED_WORKSPACE"
sid="$1"

start=$((active - WINDOW_SIZE / 2))
[ "$start" -lt 1 ] && start=1
max_start=$((TOTAL - WINDOW_SIZE + 1))
[ "$start" -gt "$max_start" ] && start=$max_start

position=$((sid - start))

if [ "$sid" = "$active" ]; then
  ICON_COLOR=$THEME_TEXT
  BG_DRAWING=on
else
  ICON_COLOR=$THEME_MUTED
  BG_DRAWING=off
fi

# --animate only tweens numeric geometry (padding, width, offsets) - color
# assignments silently no-op inside an --animate block, so colors are set
# instantly via a plain --set while padding/size animate smoothly.
if [ "$position" -ge 0 ] && [ "$position" -le $((WINDOW_SIZE - 1)) ]; then
  # fully visible slot
  sketchybar --set "$NAME" drawing=on icon.color=$ICON_COLOR background.drawing=$BG_DRAWING \
    --animate tanh 20 --set "$NAME" icon.padding_left=6 icon.padding_right=6
elif [ "$position" -eq -1 ] || [ "$position" -eq "$WINDOW_SIZE" ]; then
  # peek slot just outside the window - small and faded
  sketchybar --set "$NAME" drawing=on icon.color=$PEEK_COLOR background.drawing=off \
    --animate tanh 20 --set "$NAME" icon.padding_left=2 icon.padding_right=2
else
  # fully out of range - collapse entirely
  sketchybar --set "$NAME" drawing=off
fi
