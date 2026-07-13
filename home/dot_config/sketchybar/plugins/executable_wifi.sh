#!/bin/sh

WIFI_DEVICE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"

power_state() {
  networksetup -getairportpower "$WIFI_DEVICE" | awk '{print $4}'
}

if [ "$1" = "toggle" ]; then
  if [ "$(power_state)" = "On" ]; then
    networksetup -setairportpower "$WIFI_DEVICE" off
  else
    networksetup -setairportpower "$WIFI_DEVICE" on
  fi
  sleep 1
fi

if [ "$(power_state)" = "On" ]; then
  ICON="󰖩"
else
  ICON="󰖪"
fi

sketchybar --set wifi icon="$ICON" label=""
