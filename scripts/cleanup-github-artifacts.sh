#!/bin/bash
# Скрипт для удаления старых артефактов GitHub Actions

REPO="320kgpenguin/macos-liquid-arch"

echo "🗑️  Очистка артефактов GitHub Actions"
echo "======================================"
echo ""
echo "Репозиторий: $REPO"
echo ""

# Проверка установки gh
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) не установлен!"
    echo ""
    echo "Установите:"
    echo "  Windows: winget install GitHub.cli"
    echo "  macOS: brew install gh"
    echo "  Linux: https://cli.github.com/"
    exit 1
fi

# Проверка авторизации
if ! gh auth status &> /dev/null; then
    echo "🔐 Требуется авторизация..."
    gh auth login
fi

echo "📊 Получение списка workflow runs..."
RUNS=$(gh run list --repo "$REPO" --limit 100 --json databaseId,status,conclusion,createdAt,name)

TOTAL=$(echo "$RUNS" | jq '. | length')
echo "Найдено runs: $TOTAL"
echo ""

# Показать статистику
COMPLETED=$(echo "$RUNS" | jq '[.[] | select(.status == "completed")] | length')
FAILED=$(echo "$RUNS" | jq '[.[] | select(.conclusion == "failure")] | length')
SUCCESS=$(echo "$RUNS" | jq '[.[] | select(.conclusion == "success")] | length')

echo "Статистика:"
echo "  ✅ Успешных: $SUCCESS"
echo "  ❌ Неудачных: $FAILED"
echo "  📦 Завершенных: $COMPLETED"
echo ""

# Меню
echo "Что удалить?"
echo "  1) Все неудачные runs"
echo "  2) Все завершенные runs (кроме последних 3)"
echo "  3) Все runs старше 7 дней"
echo "  4) Все runs (кроме последних 3)"
echo "  5) Отмена"
echo ""
read -p "Выберите (1-5): " CHOICE

case $CHOICE in
    1)
        echo ""
        echo "🗑️  Удаление неудачных runs..."
        echo "$RUNS" | jq -r '.[] | select(.conclusion == "failure") | .databaseId' | while read -r ID; do
            echo "Удаление run #$ID..."
            gh run delete "$ID" --repo "$REPO" || true
        done
        ;;
    2)
        echo ""
        echo "🗑️  Удаление завершенных runs (кроме последних 3)..."
        echo "$RUNS" | jq -r '.[] | select(.status == "completed") | .databaseId' | tail -n +4 | while read -r ID; do
            echo "Удаление run #$ID..."
            gh run delete "$ID" --repo "$REPO" || true
        done
        ;;
    3)
        echo ""
        echo "🗑️  Удаление runs старше 7 дней..."
        WEEK_AGO=$(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-7d +%Y-%m-%dT%H:%M:%SZ)
        echo "$RUNS" | jq -r --arg date "$WEEK_AGO" '.[] | select(.createdAt < $date) | .databaseId' | while read -r ID; do
            echo "Удаление run #$ID..."
            gh run delete "$ID" --repo "$REPO" || true
        done
        ;;
    4)
        echo ""
        echo "🗑️  Удаление всех runs (кроме последних 3)..."
        echo "$RUNS" | jq -r '.[].databaseId' | tail -n +4 | while read -r ID; do
            echo "Удаление run #$ID..."
            gh run delete "$ID" --repo "$REPO" || true
        done
        ;;
    5)
        echo "Отменено"
        exit 0
        ;;
    *)
        echo "❌ Неверный выбор"
        exit 1
        ;;
esac

echo ""
echo "✅ Очистка завершена!"
echo ""
echo "📊 Проверьте результат:"
echo "  https://github.com/$REPO/actions"
