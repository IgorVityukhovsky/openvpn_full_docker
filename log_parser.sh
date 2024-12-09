#!/bin/sh

# Определяем интервал времени проверки в секундах
CHECK_INTERVAL=5
LOG_FILE="/tmp/openvpn-status.log"
INSTANCE=$(hostname)
METRIC_NAME="online"

while true; do
  # Проверяем наличие файла
  if [ -f "$LOG_FILE" ]; then
    # Считаем количество слов "client"
    CLIENT_COUNT=$(grep -o 'client' "$LOG_FILE" | wc -l)
    
    # Делим количество на 2
    RESULT=$((CLIENT_COUNT / 2))
    
    # Выводим результат
    echo "$RESULT"
    echo "$METRIC_NAME $RESULT" | curl --data-binary @- "http://pushgateway-prometheus-pushgateway:9091/metrics/job/online_job/instance/$INSTANCE" 2>&1
  else
    echo "Файл $LOG_FILE не найден."
  fi
  
  # Ждем заданное количество секунд перед следующей проверкой
  sleep $CHECK_INTERVAL
done
