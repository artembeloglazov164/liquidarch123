#!/usr/bin/env bash
# Этот скрипт выполняется автоматически mkarchiso

set -e -u

# Включение служб
systemctl enable NetworkManager
systemctl enable gdm

# Настройка GDM
mkdir -p /etc/gdm

# Автологин для live пользователя (опционально)
# cat > /etc/gdm/custom.conf << 'EOF'
# [daemon]
# AutomaticLoginEnable=True
# AutomaticLogin=liveuser
# EOF

# Создание скрипта автонастройки для пользователя
mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/setup-macos-style.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Setup macOS Style
Exec=/usr/local/bin/setup-macos-style.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chmod +x /usr/local/bin/setup-macos-style.sh

echo "✅ Кастомизация завершена!"
