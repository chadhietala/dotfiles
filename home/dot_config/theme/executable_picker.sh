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
