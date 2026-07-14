#!/bin/bash
# Shared "sunset" theme — single source of truth for borders, sketchybar, and
# the desktop wallpaper. Edit values here, then run ~/.config/theme/apply.sh
# to re-theme everything at once instead of hunting down hex codes per file.

# Desktop wallpaper
export THEME_WALLPAPER="$HOME/Pictures/Wallpapers/sunset.webp"

# Core palette (pulled from the wallpaper: gold meteor streaks, coral-pink
# sky, violet top, plum clouds)
export THEME_BG="0xCC2E1526"    # translucent plum-black glass (sketchybar bar/group bg)
export THEME_FG="0xfff5e8e0"    # warm cream (default text/icon color)
export THEME_GOLD="0xffffcf87"  # meteor gold (clock, weather, active workspace pill)
export THEME_CORAL="0xffff8a65" # coral (front-app default icon)
export THEME_PINK="0xffef5da0"  # magenta-pink (front-app fallback icon)
export THEME_MAUVE="0xffbd8a99" # dusty mauve (inactive workspace icon)
export THEME_ALERT="0xffff6f61" # coral-red (mic privacy alert)
export THEME_OLIVE="0xffc4d97a" # warm olive-lime (battery full)

# Window borders (JankyBorders)
export THEME_BORDER_ACTIVE="0xFFFFB870"
export THEME_BORDER_INACTIVE="0xff7a3a5c"
export THEME_BORDER_WIDTH="3.7"

# Active workspace pill background (translucent gold)
export THEME_WORKSPACE_ACTIVE_BG="0x55ffcf87"
