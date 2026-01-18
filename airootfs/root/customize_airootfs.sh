#!/usr/bin/env bash
# Этот скрипт выполняется автоматически mkarchiso

set -e -u

# Включение служб (игнорируем ошибки если сервис не существует)
systemctl enable NetworkManager || true
systemctl enable sddm || true
systemctl enable bluetooth || true
systemctl enable cups || true

# Настройка SDDM
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/kde_settings.conf << 'EOF'
[Theme]
Current=breeze

[General]
Numlock=on
EOF

# Установка пакетов из AUR
echo "📦 Установка пакетов из AUR..."

# Создание временного пользователя для сборки
useradd -m -G wheel -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Установка yay
cd /tmp
sudo -u builder bash << 'EOFYAY'
set -e
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
EOFYAY

# Установка пакетов из AUR
echo "📦 Установка Latte Dock..."
sudo -u builder yay -S --noconfirm --removemake --cleanafter latte-dock || echo "⚠️  Latte Dock не установлен"

echo "📦 Установка Calamares..."
sudo -u builder yay -S --noconfirm --removemake --cleanafter calamares || echo "⚠️  Calamares не установлен"

# Очистка
userdel -r builder 2>/dev/null || true
rm -rf /tmp/yay-bin /tmp/yay /tmp/makepkg

echo "✅ Кастомизация завершена!"

