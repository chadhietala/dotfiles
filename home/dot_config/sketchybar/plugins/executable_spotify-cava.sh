#!/bin/bash

# Persistent loop that drives the spotify item's icon with a live mini
# waveform. Started/stopped by spotify.sh as playback starts/stops.

CONF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="$CONF_DIR/spotify-cava.conf"

cava -p "$CONF_FILE" | sed -u 's/ //g; s/0/▁/g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g; s/8/█/g' | while read -r line; do
  sketchybar --set spotify icon="$line"
done
