#!/bin/bash
# Скрипт для установки AUR пакетов после установки системы

echo "🍎 Установка дополнительных компонентов macOS Liquid Arch..."

# Проверка что не запущен от root
if [ "$EUID" -eq 0 ]; then 
    echo "❌ Не запускайте этот скрипт от root!"
    exit 1
fi

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

# Установка пакетов из AUR
echo "📦 Установка Latte Dock..."
yay -S --noconfirm latte-dock

echo "📦 Установка Calamares..."
yay -S --noconfirm calamares

echo "📦 Установка дополнительных тем..."
yay -S --noconfirm kvantum-theme-materia

echo "✅ Все установлено!"
echo ""
echo "Для запуска Latte Dock выполните: latte-dock &"
echo "Или добавьте его в автозагрузку через System Settings"
