
sudo nano /usr/local/bin/cpu_alert.sh
sudo chmod +x /usr/local/bin/cpu_alert.sh
*/2 * * * * /usr/local/bin/cpu_alert.sh


#----------------------------------------------------------

#!/bin/bash

BOT_TOKEN="SEU_BOT_TOKEN"
CHAT_ID="SEU_CHAT_ID"

WARNING=75
CRITICAL=90
STATE_FILE="/tmp/cpu_state"

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU=${CPU%.*}

if [ "$CPU" -ge "$CRITICAL" ]; then
  STATE="CRITICAL"
elif [ "$CPU" -ge "$WARNING" ]; then
  STATE="WARNING"
else
  STATE="NORMAL"
fi

LAST="NONE"
[ -f "$STATE_FILE" ] && LAST=$(cat "$STATE_FILE")

if [ "$STATE" != "$LAST" ]; then
  MSG=""

  case "$STATE" in
    WARNING)
      MSG="🟡 *CPU WARNING*\n⚙️ Uso: ${CPU}%"
      ;;
    CRITICAL)
      MSG="🔴 *CPU CRITICAL*\n⚙️ Uso: ${CPU}%"
      ;;
    NORMAL)
      MSG="🟢 *CPU NORMAL*\n⚙️ Uso: ${CPU}%"
      ;;
  esac

  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d parse_mode="Markdown" \
    -d text="$MSG"

  echo "$STATE" > "$STATE_FILE"
fi
