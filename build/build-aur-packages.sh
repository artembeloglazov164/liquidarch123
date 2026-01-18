#!/bin/bash
# Предварительная сборка AUR пакетов

set -e

echo "📦 Сборка AUR пакетов..."

# Проверка что не запущен от root
if [ "$EUID" -eq 0 ]; then 
    echo "❌ Не запускайте этот скрипт от root!"
    exit 1
fi

# Создание директории для пакетов
mkdir -p ../airootfs/opt/aur-packages

# Установка yay если не установлен
if ! command -v yay &> /dev/null; then
    echo "📦 Установка yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf yay-bin
fi

# Сборка Latte Dock
echo "🔨 Сборка Latte Dock..."
cd /tmp
rm -rf latte-dock
git clone https://aur.archlinux.org/latte-dock.git
cd latte-dock
makepkg --noconfirm
cp *.pkg.tar.zst ../../airootfs/opt/aur-packages/

# Сборка Calamares
echo "🔨 Сборка Calamares..."
cd /tmp
rm -rf calamares
git clone https://aur.archlinux.org/calamares.git
cd calamares
makepkg --noconfirm
cp *.pkg.tar.zst ../../airootfs/opt/aur-packages/

# Очистка
cd /tmp
rm -rf latte-dock calamares

echo "✅ Пакеты собраны и сохранены в airootfs/opt/aur-packages/"
