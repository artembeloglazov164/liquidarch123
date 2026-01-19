#!/usr/bin/env bash
# Кастомизация 320kgpenguin (macOS Liquid Arch)

set -e -u

echo "🐧 === Начало кастомизации 320kgpenguin ==="

# Создание пользователя liveuser
echo "👤 Создание пользователя liveuser..."
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash liveuser || true
passwd -d liveuser || true
passwd -d root || true

echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Включение служб
echo "⚙️  Включение служб..."
systemctl enable NetworkManager
systemctl enable sddm
systemctl enable bluetooth || true
systemctl enable cups || true

# Настройка SDDM
echo "🎨 Настройка SDDM..."
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/autologin.conf << 'EOF'
[Autologin]
User=liveuser
Session=plasma

[Theme]
Current=breeze

[General]
Numlock=on
EOF

# Установка yay и AUR пакетов
echo "📦 Установка yay..."
cd /tmp

# Установка yay от liveuser (используем официальный метод)
sudo -u liveuser bash << 'EOFYAY'
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd /tmp
rm -rf yay
EOFYAY

echo "✅ yay установлен!"

# Установка Latte Dock
echo "🎨 Установка Latte Dock из AUR..."
sudo -u liveuser yay -S --noconfirm --removemake --cleanafter latte-dock || echo "⚠️  Latte Dock не установлен, попробуйте позже"

# Установка Calamares
echo "💿 Установка Calamares из AUR..."
sudo -u liveuser yay -S --noconfirm --removemake --cleanafter calamares || echo "⚠️  Calamares не установлен, попробуйте позже"

# Очистка кэша
sudo -u liveuser yay -Sc --noconfirm || true
rm -rf /home/liveuser/.cache/yay

# Копирование конфигов для всех пользователей
echo "📋 Копирование конфигураций..."
cp -r /etc/skel/.config /home/liveuser/ 2>/dev/null || true
cp -r /etc/skel/.local /home/liveuser/ 2>/dev/null || true
chown -R liveuser:liveuser /home/liveuser 2>/dev/null || true

# Настройка fastfetch
echo "🖥️  Настройка fastfetch..."
mkdir -p /etc/skel/.config/fastfetch
cat > /etc/skel/.config/fastfetch/config.jsonc << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "source": "macos",
        "padding": {
            "top": 1
        }
    },
    "display": {
        "separator": " "
    },
    "modules": [
        {
            "type": "custom",
            "format": "🐧 320kgpenguin (macOS Liquid Arch)"
        },
        "break",
        {
            "type": "os",
            "key": "OS",
            "keyColor": "green"
        },
        {
            "type": "kernel",
            "key": "Kernel",
            "format": "{release}"
        },
        {
            "type": "packages",
            "key": "Packages"
        },
        {
            "type": "shell",
            "key": "Shell"
        },
        {
            "type": "de",
            "key": "DE"
        },
        {
            "type": "wm",
            "key": "WM"
        },
        {
            "type": "wmtheme",
            "key": "Theme"
        },
        {
            "type": "icons",
            "key": "Icons"
        },
        {
            "type": "terminal",
            "key": "Terminal"
        },
        {
            "type": "cpu",
            "key": "CPU"
        },
        {
            "type": "gpu",
            "key": "GPU"
        },
        {
            "type": "memory",
            "key": "Memory"
        },
        {
            "type": "disk",
            "key": "Disk"
        },
        {
            "type": "uptime",
            "key": "Uptime"
        },
        "break",
        "colors"
    ]
}
EOF

# Создание /etc/os-release для 320kgpenguin
cat > /etc/os-release << 'EOF'
NAME="320kgpenguin"
PRETTY_NAME="320kgpenguin (macOS Liquid Arch)"
ID=320kgpenguin
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://github.com/320kgpenguin/macos-liquid-arch"
DOCUMENTATION_URL="https://github.com/320kgpenguin/macos-liquid-arch"
SUPPORT_URL="https://github.com/320kgpenguin/macos-liquid-arch/issues"
BUG_REPORT_URL="https://github.com/320kgpenguin/macos-liquid-arch/issues"
LOGO=archlinux
EOF

cp /etc/skel/.config/fastfetch /home/liveuser/.config/ -r 2>/dev/null || true
chown -R liveuser:liveuser /home/liveuser/.config/fastfetch 2>/dev/null || true

# Установка GRUB темы
echo "🎨 Настройка GRUB темы..."
chmod +x /usr/local/bin/install-grub-theme.sh
/usr/local/bin/install-grub-theme.sh || echo "⚠️  GRUB тема не установлена"

echo ""
echo "✅ Кастомизация завершена!"
echo ""
echo "🐧 320kgpenguin (macOS Liquid Arch) готов!"
echo ""
echo "Пользователи:"
echo "  liveuser (без пароля, автологин)"
echo "  root (без пароля)"
echo ""
echo "🍎 Установщик Calamares запустится автоматически"
echo "🎨 Latte Dock запустится автоматически"
echo ""
echo "=== Конец кастомизации ==="
