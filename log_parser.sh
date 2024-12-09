#!/bin/sh

# Определяем интервал времени проверки в секундах
CHECK_INTERVAL=${CHECK_INTERVAL:-5}  # Если переменная окружения не задана, используется значение по умолчанию
LOG_FILE="${LOG_FILE:-/tmp/openvpn-status.log}"  # Путь к файлу логов, по умолчанию /tmp/openvpn-status.log
INSTANCE="${INSTANCE:-$(hostname)}"  # Имя хоста, по умолчанию берется с помощью hostname
METRIC_NAME="${METRIC_NAME:-online}"  # Имя метрики, по умолчанию "online"
PUSHGATEWAY_URL="${PUSHGATEWAY_URL:-http://pushgateway-prometheus-pushgateway:9091}"  # URL Pushgateway

while true; do
  # Проверяем наличие файла
  if [ -f "$LOG_FILE" ]; then
    # Считаем количество слов "client"
    CLIENT_COUNT=$(grep -o 'client' "$LOG_FILE" | wc -l)
    
    # Делим количество на 2
    RESULT=$((CLIENT_COUNT / 2))
    
    # Выводим результат
    echo "$RESULT"
    echo "$METRIC_NAME $RESULT" | curl --data-binary @- "$PUSHGATEWAY_URL/metrics/job/online_job/instance/$INSTANCE" 2>&1
  else
    echo "Файл $LOG_FILE не найден."
  fi
  
  # Ждем заданное количество секунд перед следующей проверкой
  sleep $CHECK_INTERVAL
done
