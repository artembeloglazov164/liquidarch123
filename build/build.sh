#!/bin/bash
# Скрипт сборки macOS Liquid Arch ISO

set -e

echo "🍎 Начинаем сборку macOS Liquid Arch..."

# Проверка прав root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Запустите скрипт с правами root (sudo)"
    exit 1
fi

# Установка archiso если не установлен
if ! pacman -Qi archiso &> /dev/null; then
    echo "📦 Установка archiso..."
    pacman -S --noconfirm archiso
fi

# Копирование профиля
WORK_DIR="/tmp/macos-liquid-arch"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

echo "📋 Копирование профиля..."
cp -r /usr/share/archiso/configs/releng/* "$WORK_DIR/"
cp -r ../airootfs/* "$WORK_DIR/airootfs/" 2>/dev/null || true
cp ../packages.x86_64 "$WORK_DIR/"

# Сборка ISO
echo "🔨 Сборка ISO образа..."
mkarchiso -v -w "$WORK_DIR/work" -o ../out "$WORK_DIR"

# Установка AUR пакетов в chroot
echo "📦 Установка пакетов из AUR..."
arch-chroot "$WORK_DIR/work/x86_64/airootfs" /root/install-aur-packages.sh

echo "✅ Сборка завершена! ISO находится в директории out/"
