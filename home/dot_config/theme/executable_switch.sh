#!/bin/bash
# Switch the active theme and apply it live.
# Usage: switch.sh <theme-name>
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AVAILABLE="$(ls "$THEME_DIR/themes" | sed 's/\.sh$//' | tr '\n' ' ')"

NAME="${1:-}"
if [ -z "$NAME" ] || [ ! -f "$THEME_DIR/themes/$NAME.sh" ]; then
  echo "Usage: switch.sh <theme-name>" >&2
  echo "Available: $AVAILABLE" >&2
  exit 1
fi

echo "$NAME" > "$THEME_DIR/current"
THEME_NAME="$NAME" "$THEME_DIR/apply.sh"
