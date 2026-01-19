#!/bin/bash
# Скрипт для сборки ISO в Docker

set -e

echo "🐳 Сборка 320kgpenguin ISO в Docker"
echo "===================================="
echo ""

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен!"
    echo ""
    echo "Установите Docker:"
    echo "  Windows: https://docs.docker.com/desktop/install/windows-install/"
    echo "  macOS: https://docs.docker.com/desktop/install/mac-install/"
    echo "  Linux: https://docs.docker.com/engine/install/"
    exit 1
fi

# Проверка Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose не установлен!"
    exit 1
fi

# Определение команды docker compose
if docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Выбор режима сборки
echo "Выберите режим сборки:"
echo "  1) LITE - AUR пакеты устанавливаются при первом запуске (~20 мин)"
echo "  2) FULL - все устанавливается во время сборки ISO (~40 мин)"
echo ""
read -p "Режим (1/2, по умолчанию 1): " MODE_CHOICE

if [ "$MODE_CHOICE" = "2" ]; then
    SERVICE="archiso-builder-full"
    MODE_NAME="FULL"
else
    SERVICE="archiso-builder"
    MODE_NAME="LITE"
fi

echo ""
echo "📦 Сборка Docker образа ($MODE_NAME режим)..."
$DOCKER_COMPOSE build $SERVICE

echo ""
echo "🔨 Запуск сборки ISO..."
echo "Режим: $MODE_NAME"
if [ "$MODE_NAME" = "LITE" ]; then
    echo "Время: ~20-30 минут"
else
    echo "Время: ~40-60 минут"
fi
echo ""

# Запуск контейнера
$DOCKER_COMPOSE run --rm $SERVICE

echo ""
echo "✅ Сборка завершена!"
echo ""
echo "📦 ISO файл:"
ls -lh out/*.iso 2>/dev/null || echo "Ошибка: ISO не найден"
echo ""
echo "📂 Расположение: $(pwd)/out/"
