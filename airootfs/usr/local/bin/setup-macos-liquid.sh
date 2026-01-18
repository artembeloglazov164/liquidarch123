#!/bin/bash
# Скрипт настройки macOS Liquid Arch после установки

echo "🍎 Настройка macOS Liquid Arch..."

# Включение служб
systemctl enable NetworkManager
systemctl enable sddm
systemctl enable bluetooth
systemctl enable cups

# Настройка SDDM темы
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/kde_settings.conf << 'EOF'
[Theme]
Current=breeze
CursorTheme=breeze_cursors

[General]
Numlock=on
EOF

# Создание 4 рабочих столов
kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 1

# Настройка Dolphin
kwriteconfig5 --file dolphinrc --group General --key ShowFullPath true
kwriteconfig5 --file dolphinrc --group General --key ShowSpaceInfo true
kwriteconfig5 --file dolphinrc --group MainWindow --key MenuBar Disabled

# Установка обоев
mkdir -p /usr/share/wallpapers/macOS-Liquid/contents/images
# Здесь должны быть обои, можно добавить позже

echo "✅ Настройка завершена!"
