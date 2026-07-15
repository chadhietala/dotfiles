#!/bin/bash
# Opens the theme picker in a small floating, centered terminal window.
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ghostty --class=theme-picker --title="Theme Picker" \
  --window-width=60 --window-height=16 \
  -e "$THEME_DIR/picker.sh" &
GHOSTTY_PID=$!
disown

# Wait for AeroSpace to detect the window, then force it floating
# (don't rely on timing against the async on-window-detected callback).
WINDOW_ID=""
for _ in $(seq 1 30); do
  WINDOW_ID=$(aerospace list-windows --all --json 2>/dev/null | \
    python3 -c "import json,sys; ws=json.load(sys.stdin); print(next((w['window-id'] for w in ws if w.get('window-title')=='Theme Picker'), ''))" 2>/dev/null)
  [ -n "$WINDOW_ID" ] && break
  sleep 0.1
done

if [ -n "$WINDOW_ID" ]; then
  aerospace layout floating --window-id "$WINDOW_ID" >/dev/null 2>&1
fi

# Wait for the window to be visible to System Events, then center it.
# Target by PID, not process name - multiple ghostty instances all share
# the same process name, so `tell process "ghostty"` is ambiguous and can
# grab the wrong instance.
for _ in $(seq 1 30); do
  FOUND=$(osascript -e "tell application \"System Events\" to tell (first application process whose unix id is $GHOSTTY_PID) to exists (first window whose title is \"Theme Picker\")" 2>/dev/null)
  [ "$FOUND" = "true" ] && break
  sleep 0.1
done

osascript -e "
tell application \"Finder\" to set screenBounds to bounds of window of desktop
set screenW to item 3 of screenBounds
set screenH to item 4 of screenBounds
tell application \"System Events\"
  tell (first application process whose unix id is $GHOSTTY_PID)
    set targetWindow to first window whose title is \"Theme Picker\"
    set {winW, winH} to size of targetWindow
    set position of targetWindow to {(screenW - winW) / 2, (screenH - winH) / 2}
  end tell
end tell
" >/dev/null 2>&1
