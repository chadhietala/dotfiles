#!/bin/bash

# $1 is the workspace id this badge represents (passed in from sketchybarrc).
# $FOCUSED_WORKSPACE is supplied by the aerospace_workspace_change trigger.

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" icon.color=0xffffffff background.drawing=on
else
  sketchybar --set "$NAME" icon.color=0xff939ab7 background.drawing=off
fi
