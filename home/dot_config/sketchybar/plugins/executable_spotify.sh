#!/bin/bash

DEFAULT_NAME="spotify"

PLAYING_COLOR=0xffa6da95
PAUSED_COLOR=0xffffa217

MAIN_PAUSED_ICON=󰐎

PLAYER_PLAYING_ICON=󰏤
PLAYER_PAUSED_ICON=

CAVA_SCRIPT="$HOME/.config/sketchybar/plugins/spotify-cava.sh"
CAVA_PIDFILE="/tmp/sketchybar-spotify-cava.pid"
CAVA_LOCKDIR="/tmp/sketchybar-spotify-cava.lock"

start_cava() {
  # A pgrep -f match on $CAVA_SCRIPT would also match sibling spotify.sh
  # invocations' own pgrep command line (it literally contains the same
  # path string as an argument), so a PID file is used instead. Spotify's
  # notification can fire several times in a burst for one play action,
  # spawning concurrent spotify.sh runs, so the check-then-launch has to
  # happen inside the atomic mkdir lock, not before it, or two concurrent
  # invocations can both pass the "not running yet" check.
  mkdir "$CAVA_LOCKDIR" 2>/dev/null || return
  if [[ -f "$CAVA_PIDFILE" ]] && kill -0 "$(cat "$CAVA_PIDFILE")" 2>/dev/null; then
    rmdir "$CAVA_LOCKDIR" 2>/dev/null
    return
  fi
  bash "$CAVA_SCRIPT" &
  echo $! > "$CAVA_PIDFILE"
  disown
  rmdir "$CAVA_LOCKDIR" 2>/dev/null
}

stop_cava() {
  if [[ -f "$CAVA_PIDFILE" ]]; then
    kill "$(cat "$CAVA_PIDFILE")" 2>/dev/null
    rm -f "$CAVA_PIDFILE"
  fi
  # Killing the wrapper above doesn't kill its cava|sed pipeline children -
  # they'd otherwise get orphaned and keep running indefinitely.
  pkill -f "cava -p .*/spotify-cava.conf" 2>/dev/null
}

update_playpause_icon() {
  case "$PLAYER_STATE" in
    "playing"|"Playing")
      ICON=$PLAYER_PLAYING_ICON
      ;;
    *)
      ICON=$PLAYER_PAUSED_ICON
      ;;
  esac

  sketchybar --set "$DEFAULT_NAME.playpause" icon=$ICON
}

update_track() {
  # Spotify JSON / $INFO comes in malformed, line below sanitizes it
  SPOTIFY_JSON="$INFO"

  if [[ ! -z $SPOTIFY_JSON ]]; then
    PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')
    update_playpause_icon

    if [ $PLAYER_STATE = "Playing" ]; then
      TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
      ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

      start_cava
      sketchybar --set $NAME \
        label="${ARTIST} - ${TRACK}" \
        icon.color=$PLAYING_COLOR \
        icon.font.size=10 \
        label.width=dynamic icon.width=dynamic \
        background.drawing=on
    else
      stop_cava
      sketchybar --set $NAME \
        label="" icon="" \
        label.width=0 icon.width=0 \
        background.drawing=off
    fi
  else
    stop_cava
    sketchybar --set $NAME \
      label="" icon="" \
      label.width=0 icon.width=0 \
      background.drawing=off
  fi
}

mouse_clicked() {
  case "$NAME" in
    "$DEFAULT_NAME")
      osascript -e 'tell application "Spotify" to playpause'
      ;;
    "$DEFAULT_NAME.next")
      osascript -e 'tell application "Spotify" to play next track'
      ;;
    "$DEFAULT_NAME.playpause")
      osascript -e 'tell application "Spotify" to playpause'

      PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state')
      update_playpause_icon
      ;;
    "$DEFAULT_NAME.back")
      osascript -e 'tell application "Spotify" to play previous track'
      ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *)
    if [[ "$NAME" = "$DEFAULT_NAME" ]]; then
      update_track
    fi
    ;;
esac
