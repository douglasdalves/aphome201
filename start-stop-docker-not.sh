
sudo nano /usr/local/bin/docker_night_stop.sh
sudo chmod +x /usr/local/bin/docker_night_stop.sh

#!/bin/bash

BOT_TOKEN="SEU_BOT_TOKEN"
CHAT_ID="SEU_CHAT_ID"

CONTAINERS=(
  portainer
)

STOPPED=()

for c in "${CONTAINERS[@]}"; do
  if docker ps --format '{{.Names}}' | grep -qw "$c"; then
    docker stop "$c" >/dev/null
    STOPPED+=("$c")
  fi
done

if [ "${#STOPPED[@]}" -gt 0 ]; then
  MSG="🛑 *Containers desligados (modo noturno)*\n\n"
  for c in "${STOPPED[@]}"; do
    MSG+="• $c\n"
  done

  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d parse_mode="Markdown" \
    -d text="$MSG"
fi
#--------------------------------------------------------------

sudo nano /usr/local/bin/docker_morning_start.sh
sudo chmod +x /usr/local/bin/docker_morning_start.sh

#!/bin/bash

BOT_TOKEN="SEU_BOT_TOKEN"
CHAT_ID="SEU_CHAT_ID"

CONTAINERS=(
  portainer
)

STARTED=()

for c in "${CONTAINERS[@]}"; do
  if docker ps -a --format '{{.Names}}' | grep -qw "$c"; then
    if ! docker ps --format '{{.Names}}' | grep -qw "$c"; then
      docker start "$c" >/dev/null
      STARTED+=("$c")
    fi
  fi
done

if [ "${#STARTED[@]}" -gt 0 ]; then
  MSG="▶️ *Containers ligados (modo diurno)*\n\n"
  for c in "${STARTED[@]}"; do
    MSG+="• $c\n"
  done

  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d parse_mode="Markdown" \
    -d text="$MSG"
fi


