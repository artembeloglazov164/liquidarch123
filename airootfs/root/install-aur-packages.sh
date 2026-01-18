#!/bin/bash
# Установка пакетов из AUR для ISO

set -e

echo "📦 Установка пакетов из AUR..."

# Создание временного пользователя для сборки
useradd -m -G wheel -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Установка yay
cd /tmp
sudo -u builder bash << 'EOF'
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
EOF

# Установка пакетов из AUR
sudo -u builder yay -S --noconfirm \
    latte-dock-git \
    calamares \
    kvantum-theme-materia

# Очистка
userdel -r builder
rm -rf /tmp/yay-bin

echo "✅ Пакеты из AUR установлены!"
