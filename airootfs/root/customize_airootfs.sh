#!/usr/bin/env bash
# Этот скрипт выполняется автоматически mkarchiso

set -e -u

# Включение служб
systemctl enable NetworkManager
systemctl enable sddm

# Настройка SDDM
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/kde_settings.conf << 'EOF'
[Theme]
Current=breeze

[General]
Numlock=on
EOF

# Установка предсобранных AUR пакетов
if [ -d /opt/aur-packages ]; then
    echo "📦 Установка предсобранных AUR пакетов..."
    pacman -U --noconfirm /opt/aur-packages/*.pkg.tar.zst || echo "⚠️  Некоторые пакеты не установлены"
    rm -rf /opt/aur-packages
fi

# Включение автозапуска Calamares в Live режиме
systemctl enable calamares-autostart.service || true

echo "✅ Кастомизация завершена!"

