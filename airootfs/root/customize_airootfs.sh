#!/usr/bin/env bash
# Этот скрипт выполняется автоматически mkarchiso

set -e -u

# Создание пользователя liveuser
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash liveuser
# Пустой пароль для liveuser
passwd -d liveuser
# Пустой пароль для root
passwd -d root

# Разрешить wheel группе sudo без пароля
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Включение служб
systemctl enable NetworkManager
systemctl enable gdm

# Настройка GDM с автологином
mkdir -p /etc/gdm
cat > /etc/gdm/custom.conf << 'EOF'
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser

[security]

[xdmcp]

[chooser]

[debug]
EOF

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

# Копирование настроек для liveuser
cp -r /etc/skel/.config /home/liveuser/ 2>/dev/null || true
chown -R liveuser:liveuser /home/liveuser

echo "✅ Кастомизация завершена!"
echo ""
echo "Пользователи:"
echo "  liveuser (без пароля, автологин)"
echo "  root (без пароля)"


