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

echo "✅ Тема MacVentura установлена!"

# Применение темы для текущего пользователя
if [ -n "$USER" ] && [ "$USER" != "root" ]; then
    echo "🎨 Применение темы для пользователя $USER..."
    
    # Установка Kvantum темы
    if command -v kvantummanager &> /dev/null; then
        # Применение темы Kvantum
        mkdir -p "$HOME/.config/Kvantum"
        echo "theme=MacVentura" > "$HOME/.config/Kvantum/kvantum.kvconfig"
        echo "✅ Kvantum тема применена"
    fi
    
    # Применение глобальной темы KDE
    kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage "com.github.vinceliuice.MacVentura-Dark"
    
    # Применение цветовой схемы
    kwriteconfig5 --file kdeglobals --group General --key ColorScheme "MacVenturaDark"
    
    # Применение темы окон (Aurorae)
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__MacVentura-Dark"
    
    # Применение темы Plasma
    kwriteconfig5 --file plasmarc --group Theme --key name "MacVentura-Dark"
    
    # Установка обоев
    kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 1 --group Wallpaper --group org.kde.image --group General --key Image "file:///usr/share/wallpapers/MacVentura-Dark/contents/images/3840x2160.png"
    
    echo "✅ Тема применена для KDE Plasma"
fi

echo ""
echo "🎨 Тема MacVentura установлена и применена!"
echo ""
echo "Рекомендации:"
echo "  - Установите WhiteSur icon theme (из AUR)"
echo "  - Установите WhiteSur cursors (из AUR)"
echo "  - Перезагрузите KDE для полного применения темы"
echo ""
