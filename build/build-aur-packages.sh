#!/bin/bash
# Предварительная сборка AUR пакетов

echo "📦 Сборка AUR пакетов..."

# Создание директории для пакетов
mkdir -p ../airootfs/opt/aur-packages

# Установка зависимостей для сборки
sudo pacman -S --needed --noconfirm git base-devel

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

# Получаем абсолютный путь к директории проекта
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$PROJECT_DIR/airootfs/opt/aur-packages"

# Сборка Latte Dock (ОБЯЗАТЕЛЬНО)
echo "🔨 Сборка Latte Dock..."
cd /tmp
rm -rf latte-dock
git clone https://aur.archlinux.org/latte-dock.git
cd latte-dock

# Установка зависимостей для сборки
echo "📦 Установка зависимостей Latte Dock..."
sudo pacman -S --needed --noconfirm plasma-desktop plasma-workspace kwayland qt5-x11extras

makepkg --noconfirm --skippgpcheck
cp *.pkg.tar.zst "$PACKAGES_DIR/"

# Сборка Calamares
echo "🔨 Сборка Calamares..."
cd /tmp
rm -rf calamares
git clone https://aur.archlinux.org/calamares.git
cd calamares
makepkg --noconfirm --skippgpcheck || echo "⚠️  Calamares не собрался"
if ls *.pkg.tar.zst 1> /dev/null 2>&1; then
    cp *.pkg.tar.zst "$PACKAGES_DIR/"
fi

# Очистка
cd /tmp
rm -rf latte-dock calamares

echo "✅ Сборка завершена!"
ls -lh "$PACKAGES_DIR/"

