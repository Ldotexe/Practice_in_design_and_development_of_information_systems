#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <URL_REPO> <BRANCH_1> <BRANCH_2>"
    exit 1
fi

REPO_URL=$1
BRANCH1=$2
BRANCH2=$3
CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
OUTPUT_FILE="diff_report_${BRANCH1////__}_vs_${BRANCH2////__}.txt"


TEMP_DIR=$(mktemp -d)
echo "Клонирование репозитория во временную папку..."

git clone -q "$REPO_URL" "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "Ошибка при клонировании репозитория."
    rm -rf "$TEMP_DIR"
    exit 1
fi

cd "$TEMP_DIR" || exit

if ! git rev-parse --verify "origin/$BRANCH1" >/dev/null 2>&1 || \
   ! git rev-parse --verify "origin/$BRANCH2" >/dev/null 2>&1; then
    echo "Ошибка: Одна из веток не существует в удаленном репозитории."
    cd ..
    rm -rf "$TEMP_DIR"
    exit 1
fi

DIFF_OUTPUT=$(git diff --name-status "origin/$BRANCH1" "origin/$BRANCH2")

COUNT_TOTAL=$(echo "$DIFF_OUTPUT" | wc -l)
COUNT_A=$(echo "$DIFF_OUTPUT" | grep "^A" | wc -l)
COUNT_M=$(echo "$DIFF_OUTPUT" | grep "^M" | wc -l)
COUNT_D=$(echo "$DIFF_OUTPUT" | grep "^D" | wc -l)

cd - > /dev/null

{
    echo "Отчет о различиях между ветками"
    echo ""
    echo "================================"
    echo "Репозиторий: $REPO_URL"
    echo "Ветка 1: $BRANCH1"
    echo "Ветка 2: $BRANCH2"
    echo "Дата генерации: $CURRENT_DATE"
    echo "================================"
    echo ""
    echo "СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:"
    echo "$DIFF_OUTPUT"
    echo ""
    echo "СТАТИСТИКА:"
    echo "Всего измененных файлов: $COUNT_TOTAL"
    echo "Добавлено (A): $COUNT_A"
    echo "Удалено (D): $COUNT_D"
    echo "Изменено (M): $COUNT_M"
} > "$OUTPUT_FILE"

rm -rf "$TEMP_DIR"

echo "Отчет сформирован: $OUTPUT_FILE"