#!/bin/sh

CACHE_DIR="$HOME/.local/state/waybar_stocks"
mkdir -p $CACHE_DIR
CACHE_FILE="$CACHE_DIR/stock_$1.last"

# Get current time in New York
now_et=$(TZ=America/New_York date +'%H:%M')
weekday_et=$(TZ=America/New_York date +%u)

is_market_time=0

# Check for weekday (Mon-Fri) and time between 09:30 and 16:00
if [ "$weekday_et" -ge 1 ] && [ "$weekday_et" -le 5 ]; then
    if [ "$now_et" \> "09:29" ] && [ "$now_et" \< "16:01" ]; then
        is_market_time=1
    fi
fi

# echo "It is currently day $weekday_et - $now_et in nASDAQ. is_market_time: $is_market_time"
#
if [ "$is_market_time" -eq 0 ]; then
  exit
fi

if [ "$is_market_time" -eq 1 ] || [ ! -f "$CACHE_FILE" ]; then
    curl -s -o "$CACHE_FILE" "https://eodhd.com/api/real-time/$1.US?api_token=$EODHD_API_KEY&fmt=json" 
fi

price=$(cat "$CACHE_FILE" | jq .close)
change=$(cat "$CACHE_FILE" | jq .change)

# Decide class
class="neutral"
change_abs=$(echo "$change" | awk '{print ($1 >= 0) ? $1 : -$1}')
if awk "BEGIN {exit !($change > 0)}"; then
    class="stock-up"
elif awk "BEGIN {exit !($change < 0)}"; then
    class="stock-down"
fi

cat <<EOF
{"text": "$change","tooltip": "$price","class": "$class"}
EOF

