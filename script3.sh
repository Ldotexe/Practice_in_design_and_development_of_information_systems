#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <LOG_FILE> <KEYWORD>"
    exit 1
fi

LOG_FILE=$1
KEYWORD=$2
OUTPUT_FILE="found_errors_${KEYWORD}.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "Файл $LOG_FILE не найден!"
    exit 1
fi

grep "$KEYWORD" "$LOG_FILE" > "$OUTPUT_FILE"

COUNT=$(wc -l < "$OUTPUT_FILE")

echo "========================================"
echo "Анализ завершен."
echo "Файл: $LOG_FILE"
echo "Ключевое слово: \"$KEYWORD\""
echo "Найдено совпадений: $COUNT"
echo "Результаты сохранены в: $OUTPUT_FILE"
echo "========================================"