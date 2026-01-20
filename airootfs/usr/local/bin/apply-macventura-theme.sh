#!/bin/bash
# Применение темы MacVentura для пользователя через конфигурационные файлы

set -e

USER_HOME="${HOME:-/home/$USER}"

echo "🎨 Применение темы MacVentura для $USER..."

# Создание директорий
mkdir -p "$USER_HOME/.config/Kvantum"
mkdir -p "$USER_HOME/.config"

# Применение Kvantum темы
cat > "$USER_HOME/.config/Kvantum/kvantum.kvconfig" << 'EOF'
[General]
theme=MacVentura
EOF

# Применение глобальной темы KDE через kdeglobals
cat > "$USER_HOME/.config/kdeglobals" << 'EOF'
[KDE]
LookAndFeelPackage=com.github.vinceliuice.MacVentura-Dark

[General]
ColorScheme=MacVenturaDark

[Icons]
Theme=WhiteSur-dark

[WM]
activeBackground=30,30,46
activeBlend=30,30,46
activeForeground=205,214,244
inactiveBackground=30,30,46
inactiveBlend=30,30,46
inactiveForeground=108,112,134
EOF

# Применение темы окон (kwinrc)
cat > "$USER_HOME/.config/kwinrc" << 'EOF'
[org.kde.kdecoration2]
theme=__aurorae__svg__MacVentura-Dark
ButtonsOnLeft=XIA
ButtonsOnRight=
EOF

# Применение темы Plasma (plasmarc)
cat > "$USER_HOME/.config/plasmarc" << 'EOF'
[Theme]
name=MacVentura-Dark
EOF

# Применение курсоров (kcminputrc)
cat > "$USER_HOME/.config/kcminputrc" << 'EOF'
[Mouse]
cursorTheme=WhiteSur-cursors
EOF

# Установка прав
if [ "$USER" != "root" ]; then
    chown -R $USER:$USER "$USER_HOME/.config" 2>/dev/null || true
fi

echo "✅ Тема MacVentura применена!"
echo ""
echo "Настройки:"
echo "  - Global Theme: MacVentura-Dark"
echo "  - Color Scheme: MacVenturaDark"
echo "  - Window Decorations: MacVentura-Dark"
echo "  - Plasma Theme: MacVentura-Dark"
echo "  - Icons: WhiteSur-dark"
echo "  - Cursors: WhiteSur-cursors"
echo "  - Kvantum: MacVentura"
echo ""
