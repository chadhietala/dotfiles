#!/bin/bash
source "$HOME/.config/theme/theme.sh"

CACHE_FILE="/tmp/sketchybar_weather_location.cache"
CACHE_TTL=3600  # 1 hour; IP-based location rarely changes minute to minute

get_location() {
  if [ -f "$CACHE_FILE" ]; then
    CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    if [ "$CACHE_AGE" -lt "$CACHE_TTL" ]; then
      cat "$CACHE_FILE"
      return
    fi
  fi

  LOCATION_JSON=$(curl -s --max-time 5 "https://ipwho.is/")
  if [ -n "$LOCATION_JSON" ] && echo "$LOCATION_JSON" | jq -e '.success == true' >/dev/null 2>&1; then
    echo "$LOCATION_JSON" > "$CACHE_FILE"
    echo "$LOCATION_JSON"
  fi
}

LOCATION_JSON=$(get_location)

if [ -z "$LOCATION_JSON" ]; then
  sketchybar --set $NAME label="N/A"
  exit 0
fi

LAT=$(echo "$LOCATION_JSON" | jq '.latitude')
LON=$(echo "$LOCATION_JSON" | jq '.longitude')

WEATHER_JSON=$(curl -s --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code")

if [ -z "$WEATHER_JSON" ]; then
  sketchybar --set $NAME label="N/A"
  exit 0
fi

TEMPERATURE=$(echo "$WEATHER_JSON" | jq '.current.temperature_2m | round')
CODE=$(echo "$WEATHER_JSON" | jq '.current.weather_code')

case $CODE in
  0)                    DESC="Clear sky" ;;
  1)                    DESC="Mainly clear" ;;
  2)                    DESC="Partly cloudy" ;;
  3)                    DESC="Overcast" ;;
  45|48)                DESC="Fog" ;;
  51|53|55)             DESC="Drizzle" ;;
  56|57)                DESC="Freezing drizzle" ;;
  61|63|65)             DESC="Rain" ;;
  66|67)                DESC="Freezing rain" ;;
  71|73|75|77)          DESC="Snow" ;;
  80|81|82)             DESC="Rain showers" ;;
  85|86)                DESC="Snow showers" ;;
  95|96|99)             DESC="Thunderstorm" ;;
  *)                    DESC="Unknown" ;;
esac

sketchybar --set $NAME \
  icon=󰖐 icon.color=$THEME_GOLD \
  label="${TEMPERATURE}°C • ${DESC}"
