#!/bin/bash

PID_FILE="/tmp/system_monitor.pid"

start_monitoring() {
    while true; do
        REPORT_FILE="system_report_$(date +%Y-%m-%d).csv"
        
        if [ ! -f "$REPORT_FILE" ]; then
            echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$REPORT_FILE"
        fi

        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        MEM_INFO=$(free -m)
        MEM_TOTAL=$(echo "$MEM_INFO" | awk '/Mem:/ {print $2}')
        MEM_FREE=$(echo "$MEM_INFO" | awk '/Mem:/ {print $4}')
        MEM_USED_PERCENT=$(echo "$MEM_INFO" | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')
        CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')
        CPU_USED=$(echo "100 - $CPU_IDLE" | bc)
        DISK_USED=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
        LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

        echo "$TIMESTAMP;$MEM_TOTAL;$MEM_FREE;$MEM_USED_PERCENT;$CPU_USED;$DISK_USED;$LOAD_AVG" >> "$REPORT_FILE"

        sleep 5
    done
}

case "$1" in
    START)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Скрипт уже запущен (PID: $(cat $PID_FILE))."
        else
            start_monitoring & 
            NEW_PID=$!
            echo "$NEW_PID" > "$PID_FILE"
            echo "Мониторинг запущен. PID: $NEW_PID"
        fi
        ;;
    STOP)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                kill "$PID"
                rm "$PID_FILE"
                echo "Мониторинг остановлен (PID: $PID)."
            else
                echo "Процесс не найден, но PID-файл удален."
                rm "$PID_FILE"
            fi
        else
            echo "Скрипт не запущен (PID-файл отсутствует)."
        fi
        ;;
    STATUS)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Статус: ЗАПУЩЕН (PID: $(cat $PID_FILE))"
        else
            echo "Статус: ОСТАНОВЛЕН"
        fi
        ;;
    *)
        echo "Использование: $0 {START|STOP|STATUS}"
        exit 1
        ;;
esac