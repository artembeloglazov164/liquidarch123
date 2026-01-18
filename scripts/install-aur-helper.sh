#!/bin/bash
# Установка yay - AUR helper

set -e

echo "📦 Установка yay (AUR helper)..."

# Проверка, не запущен ли скрипт от root
if [ "$EUID" -eq 0 ]; then 
    echo "❌ Не запускайте этот скрипт от root!"
    exit 1
fi

# Установка зависимостей
sudo pacman -S --needed --noconfirm git base-devel

# Клонирование yay
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay

# Сборка и установка
makepkg -si --noconfirm

# Очистка
cd ..
rm -rf yay

echo "✅ yay установлен!"
echo "Теперь вы можете устанавливать пакеты из AUR:"
echo "  yay -S имя_пакета"
