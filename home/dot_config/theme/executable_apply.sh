#!/bin/bash
# Applies the current theme: desktop wallpaper, window borders, and sketchybar.
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$THEME_DIR/theme.sh"

# Desktop wallpaper
if [ -f "$THEME_WALLPAPER" ]; then
  osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$THEME_WALLPAPER\"" >/dev/null
fi

# Ghostty terminal theme
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
if [ -n "${THEME_GHOSTTY:-}" ] && [ -f "$GHOSTTY_CONFIG" ]; then
  sed -i '' "s/^theme = .*/theme = $THEME_GHOSTTY/" "$GHOSTTY_CONFIG"
fi

# Window borders (kill any running instance, JankyBorders dedupes on launch)
pkill -x borders 2>/dev/null || true
sleep 0.2
"$HOME/.config/aerospace/start-borders.sh" &
disown

# Sketchybar (re-running the rc script re-applies config to the live bar)
"$HOME/.config/sketchybar/sketchybarrc"

echo "Theme applied."
