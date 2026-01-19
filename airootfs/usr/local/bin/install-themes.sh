#!/bin/bash
# Установка тем macOS из ZIP файлов

echo "🎨 Установка тем macOS из ZIP файлов..."

THEMES_DIR="/usr/share/320kgpenguin-themes"

if [ ! -d "$THEMES_DIR" ]; then
    echo "⚠️  Директория с темами не найдена: $THEMES_DIR"
    exit 0
fi

# Создание директорий для тем
mkdir -p ~/.local/share/plasma/plasmoids
mkdir -p ~/.local/share/plasma/look-and-feel
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/wallpapers
mkdir -p ~/.config/latte
mkdir -p ~/.config/albert
mkdir -p /usr/share/plymouth/themes

echo "📦 Распаковка тем..."

# Fonts
if [ -f "$THEMES_DIR/fonts.zip" ]; then
    echo "  → Шрифты macOS..."
    unzip -q -o "$THEMES_DIR/fonts.zip" -d ~/.local/share/fonts/
    fc-cache -f
fi

# Wallpapers
if [ -f "$THEMES_DIR/wallpapers.zip" ]; then
    echo "  → Обои macOS..."
    unzip -q -o "$THEMES_DIR/wallpapers.zip" -d ~/.local/share/wallpapers/
fi

# Plasmoids (виджеты)
if [ -f "$THEMES_DIR/plasmoids.zip" ]; then
    echo "  → Plasmoids (виджеты)..."
    unzip -q -o "$THEMES_DIR/plasmoids.zip" -d ~/.local/share/plasma/plasmoids/
fi

# Latte Dock Layout
if [ -f "$THEMES_DIR/latte-dock-layout.zip" ]; then
    echo "  → Latte Dock layout..."
    unzip -q -o "$THEMES_DIR/latte-dock-layout.zip" -d ~/.config/latte/
fi

# Top Panel
if [ -f "$THEMES_DIR/top-panel.zip" ]; then
    echo "  → Top Panel (верхняя панель)..."
    unzip -q -o "$THEMES_DIR/top-panel.zip" -d ~/.config/
fi

# Albert Theme
if [ -f "$THEMES_DIR/albert-theme-macos.zip" ]; then
    echo "  → Albert launcher theme..."
    unzip -q -o "$THEMES_DIR/albert-theme-macos.zip" -d ~/.config/albert/
fi

# Plymouth (загрузочный экран)
if [ -f "$THEMES_DIR/macos-plymouth.zip" ]; then
    echo "  → Plymouth theme (загрузочный экран)..."
    sudo unzip -q -o "$THEMES_DIR/macos-plymouth.zip" -d /usr/share/plymouth/themes/
fi

echo "✅ Темы распакованы!"

# Применение настроек
echo "🎨 Применение настроек..."

# Установка обоев
if [ -d ~/.local/share/wallpapers/macOS ]; then
    WALLPAPER=$(find ~/.local/share/wallpapers/macOS -name "*.jpg" -o -name "*.png" | head -n 1)
    if [ -n "$WALLPAPER" ]; then
        kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 1 --group Wallpaper --group org.kde.image --group General --key Image "file://$WALLPAPER"
        echo "  ✓ Обои установлены"
    fi
fi

# Настройка шрифтов
if [ -d ~/.local/share/fonts ]; then
    kwriteconfig5 --file kdeglobals --group General --key font "SF Pro Display,10,-1,5,50,0,0,0,0,0"
    kwriteconfig5 --file kdeglobals --group General --key fixed "SF Mono,10,-1,5,50,0,0,0,0,0"
    echo "  ✓ Шрифты настроены"
fi

# Импорт Latte Dock layout
if [ -f ~/.config/latte/macOS.layout.latte ]; then
    # Latte Dock автоматически загрузит layout при запуске
    echo "  ✓ Latte Dock layout готов"
fi

echo ""
echo "✅ Все темы установлены и применены!"
echo ""
echo "📦 Установлено:"
echo "  ✓ Шрифты macOS"
echo "  ✓ Обои macOS"
echo "  ✓ Plasmoids (виджеты)"
echo "  ✓ Latte Dock layout"
echo "  ✓ Top Panel (верхняя панель)"
echo "  ✓ Albert theme"
echo "  ✓ Plymouth theme"
echo ""
echo "⚠️  Перезагрузите Plasma для применения всех изменений:"
echo "   killall plasmashell && kstart5 plasmashell"

