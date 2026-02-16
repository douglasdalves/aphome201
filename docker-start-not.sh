#!/bin/bash

# Carrega variáveis do Telegram
source /usr/local/bin/telegram.conf


send_telegram() {
  local MESSAGE="$1"
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${MESSAGE}" > /dev/null
}

# ===== CONTAINERS =====
CONTAINERS=(
  portainer
  dc-filebrowser
  dc-sftpgo
)

ERRORS=0
REPORT="📦 *Relatório de Start Containers*%0A"

for c in "${CONTAINERS[@]}"; do
  if ! docker ps -a --format '{{.Names}}' | grep -q "^${c}$"; then
    REPORT+="❌ ${c} não existe%0A"
    ((ERRORS++))
    continue
  fi

  OUTPUT=$(docker start "$c" 2>&1)
  STATUS=$?

  if [ $STATUS -eq 0 ]; then
    sleep 2
    if docker ps --format '{{.Names}}' | grep -q "^${c}$"; then
      REPORT+="✅ ${c} iniciado com sucesso%0A"
    else
      REPORT+="⚠️ ${c} iniciou mas não está rodando%0A"
      ((ERRORS++))
    fi
  else
    REPORT+="❌ Erro ao iniciar ${c}%0A${OUTPUT}%0A"
    ((ERRORS++))
  fi
done

if [ $ERRORS -gt 0 ]; then
  send_telegram "$REPORT"
else
  REPORT+="🎉 Todos iniciados com sucesso"
  send_telegram "$REPORT"
fi
