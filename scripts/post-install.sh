#!/bin/bash
# Скрипт выполняется после установки системы

echo "🍎 Финальная настройка macOS Liquid Arch..."

# Включение multilib репозитория
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
fi

# Обновление базы пакетов
pacman -Sy

# Настройка рабочих столов
kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 1

# Включение композитинга
kwriteconfig5 --file kwinrc --group Compositing --key Enabled true
kwriteconfig5 --file kwinrc --group Compositing --key Backend OpenGL
kwriteconfig5 --file kwinrc --group Compositing --key GLCore true

# Настройка эффектов
kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig5 --file kwinrc --group Plugins --key magiclampEnabled true
kwriteconfig5 --file kwinrc --group Plugins --key slideEnabled true

# Перезагрузка KWin
qdbus org.kde.KWin /KWin reconfigure

echo "✅ Настройка завершена!"
echo "🎉 Добро пожаловать в macOS Liquid Arch!"
