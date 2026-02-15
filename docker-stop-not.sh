#!/bin/bash

# ===== CONFIG TELEGRAM =====
BOT_TOKEN=""
CHAT_ID=""

send_telegram() {
  local MESSAGE="$1"
  curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}" > /dev/null
}

# ===== CONTAINERS =====
CONTAINERS=(
  portainer
  dc-filebrowser
  dc-sftpgo
)

ERRORS=0
REPORT="🛑 Relatório de Stop Containers%0A"

for c in "${CONTAINERS[@]}"; do
  if ! docker ps -a --format '{{.Names}}' | grep -q "^${c}$"; then
    REPORT+="❌ ${c} não existe%0A"
    ((ERRORS++))
    continue
  fi

  if docker ps --format '{{.Names}}' | grep -q "^${c}$"; then
    OUTPUT=$(docker stop "$c" 2>&1)
    STATUS=$?

    if [ $STATUS -eq 0 ]; then
      sleep 2
      if docker ps --format '{{.Names}}' | grep -q "^${c}$"; then
        REPORT+="⚠️ ${c} ainda está rodando%0A"
        ((ERRORS++))
      else
        REPORT+="✅ ${c} parado com sucesso%0A"
      fi
    else
      REPORT+="❌ Erro ao parar ${c}%0A${OUTPUT}%0A"
      ((ERRORS++))
    fi
  else
    REPORT+="ℹ️ ${c} já estava parado%0A"
  fi
done

send_telegram "$REPORT"
