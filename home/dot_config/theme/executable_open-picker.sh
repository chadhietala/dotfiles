#!/bin/bash
# Opens the theme picker in a small floating, centered terminal window.
#
# Everything below targets the window by PID, not title. Ghostty's shell
# integration ("title" feature) rewrites the window title once the
# interactive shell/gum takes over, so a static --title="Theme Picker"
# flag only holds briefly right after launch - matching by title races
# that rewrite and intermittently fails. PID is stable for the process's
# whole lifetime and this process only ever owns one window.
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

/Applications/Ghostty.app/Contents/MacOS/ghostty --class=theme-picker --title="Theme Picker" \
  --window-width=60 --window-height=16 \
  -e "$THEME_DIR/picker.sh" &
GHOSTTY_PID=$!
disown

# Wait for AeroSpace to detect the window, then force it floating
# (don't rely on timing against the async on-window-detected callback).
# Note: --pid requires a scope flag too ("--monitor all", not "--all" -
# that alias conflicts with filtering flags).
WINDOW_ID=""
for _ in $(seq 1 30); do
  WINDOW_ID=$(/opt/homebrew/bin/aerospace list-windows --monitor all --pid "$GHOSTTY_PID" --json 2>/dev/null | \
    /usr/bin/python3 -c "import json,sys; ws=json.load(sys.stdin); print(ws[0]['window-id'] if ws else '')" 2>/dev/null)
  [ -n "$WINDOW_ID" ] && break
  sleep 0.05
done

if [ -n "$WINDOW_ID" ]; then
  /opt/homebrew/bin/aerospace layout floating --window-id "$WINDOW_ID" >/dev/null 2>&1
fi

# Wait for the window to be visible to System Events, then center it.
for _ in $(seq 1 30); do
  FOUND=$(/usr/bin/osascript -e "tell application \"System Events\" to tell (first application process whose unix id is $GHOSTTY_PID) to exists window 1" 2>/dev/null)
  [ "$FOUND" = "true" ] && break
  sleep 0.05
done

/usr/bin/osascript -e "
tell application \"Finder\" to set screenBounds to bounds of window of desktop
set screenW to item 3 of screenBounds
set screenH to item 4 of screenBounds
tell application \"System Events\"
  tell (first application process whose unix id is $GHOSTTY_PID)
    set {winW, winH} to size of window 1
    set position of window 1 to {(screenW - winW) / 2, (screenH - winH) / 2}
  end tell
end tell
" >/dev/null 2>&1
