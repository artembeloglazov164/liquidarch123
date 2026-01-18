#!/bin/bash
# Установка дополнительных тем и иконок

set -e

echo "🎨 Установка дополнительных тем..."

# Проверка наличия yay
if ! command -v yay &> /dev/null; then
    echo "❌ yay не установлен. Запустите install-aur-helper.sh сначала"
    exit 1
fi

# Темы Kvantum
echo "📦 Установка Kvantum тем..."
yay -S --noconfirm \
    kvantum-theme-materia \
    kvantum-theme-adapta \
    kvantum-theme-arc

# Иконки
echo "🎨 Установка пакетов иконок..."
sudo pacman -S --noconfirm papirus-icon-theme
yay -S --noconfirm \
    tela-icon-theme \
    candy-icons-git

# Курсоры
echo "🖱️ Установка курсоров..."
yay -S --noconfirm \
    apple-cursor \
    capitaine-cursors

# Шрифты
echo "🔤 Установка шрифтов..."
yay -S --noconfirm \
    apple-fonts \
    ttf-ms-fonts \
    ttf-mac-fonts

# Обои
echo "🖼️ Установка обоев..."
yay -S --noconfirm \
    plasma5-wallpapers-dynamic \
    archlinux-wallpaper

echo "✅ Темы установлены!"
echo "Настройте их через System Settings → Appearance"
