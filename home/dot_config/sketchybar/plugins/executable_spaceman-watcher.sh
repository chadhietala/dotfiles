#!/bin/bash
# Polls Spaceman's active workspace and fires aerospace_workspace_change when it changes.
# Subscribed to front_app_switched (instant on most switches) + update_freq=1 (fallback).

SPACEMAN="/Applications/Spaceman.app/Contents/MacOS/spaceman"
CACHE="/tmp/sketchybar-spaceman-ws"

status=$("$SPACEMAN" ctl status 2>/dev/null) || exit 0
# Extract the first active workspace from {"active_workspaces":[2,...],...}
ws=$(printf '%s' "$status" | sed -n 's/.*"active_workspaces":\[\([^],]*\).*/\1/p' | tr -d '"')
[ -z "$ws" ] && exit 0

prev=$(cat "$CACHE" 2>/dev/null)
if [ "$ws" != "$prev" ]; then
  printf '%s' "$ws" > "$CACHE"
  sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$ws"
fi
