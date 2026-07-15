#!/bin/bash
# Fuzzy-search theme picker. Runs inside the floating terminal opened by
# open-picker.sh; not meant to be run directly in a normal shell.
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$THEME_DIR/theme.sh"

ACCENT="#$(echo "$THEME_ACCENT" | cut -c5-10)"

CHOICE=$(
  ls "$THEME_DIR/themes" | sed 's/\.sh$//' | \
  gum filter \
    --placeholder="Search themes..." \
    --header="Select a theme" \
    --indicator.foreground="$ACCENT" \
    --match.foreground="$ACCENT"
)

if [ -n "$CHOICE" ]; then
  "$THEME_DIR/switch.sh" "$CHOICE"
fi

echo
echo "Press any key to close..."
read -n 1 -s

# Fully quit this picker instance - Ghostty (like most Mac apps) stays
# running with no windows open otherwise. Matched by the unique --class
# flag so this can't touch any other Ghostty windows. Graceful AppleScript
# quit rather than a raw pkill, since it's the more correct way to
# terminate a Cocoa app. (A stray Dock icon after this was a separate
# issue - macOS's "recent apps" Dock feature, unrelated to how the
# process exits - fixed by disabling com.apple.dock show-recents.)
GHOSTTY_PID=$(/usr/bin/pgrep -f -- "--class=theme-picker")
if [ -n "$GHOSTTY_PID" ]; then
  /usr/bin/osascript -e "tell application \"System Events\" to tell (first application process whose unix id is $GHOSTTY_PID) to quit" >/dev/null 2>&1
fi
