#!/bin/bash
# "tokyo-night" theme — Ghostty's actual TokyoNight Storm palette (pulled
# from the bundled theme file), paired with a neon night-alley wallpaper.

export THEME_WALLPAPER="$HOME/Pictures/Wallpapers/tokyo-night.png"
export THEME_GHOSTTY="TokyoNight Storm"

export THEME_SURFACE="0xCC24283b"    # translucent storm-blue (sketchybar bar/group bg)
export THEME_TEXT="0xffc0caf5"    # soft lavender-white (default text/icon color)
export THEME_ACCENT="0xff7aa2f7"  # blue (clock, weather, active workspace pill)
export THEME_ACCENT_SECONDARY="0xff7dcfff" # cyan (front-app default icon)
export THEME_ACCENT_TERTIARY="0xffbb9af7"  # purple (front-app fallback icon)
export THEME_MUTED="0xffa9b1d6" # muted lavender-gray (inactive workspace icon)
export THEME_DANGER="0xfff7768e" # red (mic privacy alert)
export THEME_SUCCESS="0xff9ece6a" # green (battery full)

# Window borders (JankyBorders)
# Integer width only - fractional values (e.g. 3.7) caused a stray render
# artifact where AeroSpace tiles windows together.
export THEME_BORDER_ACTIVE="0xFF7dcfff"
export THEME_BORDER_INACTIVE="0xff4e5575"
export THEME_BORDER_WIDTH="4"

# Active workspace pill background (translucent blue)
export THEME_ACCENT_SUBTLE="0x557aa2f7"
