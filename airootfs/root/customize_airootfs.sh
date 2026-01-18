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

echo "✅ Кастомизация завершена!"

