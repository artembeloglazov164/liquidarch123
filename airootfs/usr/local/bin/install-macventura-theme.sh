#!/bin/bash
# Установка темы MacVentura для KDE Plasma

set -e

echo "🍎 Установка темы MacVentura..."

THEME_DIR="/usr/share/macventura-theme"

if [ ! -d "$THEME_DIR" ]; then
    echo "❌ Тема MacVentura не найдена в $THEME_DIR"
    exit 1
fi

# Установка темы от root (системная установка)
cd "$THEME_DIR"
bash install.sh --round --color dark

echo "✅ Тема MacVentura установлена системно!"
echo ""
echo "Тема будет применена автоматически при первом входе в KDE"
echo ""
