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

# Установка yay-bin (бинарная версия, не требует компиляции Go)
sudo -u liveuser bash << 'EOFYAY'
set -e
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd /tmp
rm -rf yay-bin
EOFYAY

echo "✅ yay установлен!"

# Установка Latte Dock из AUR
echo "🎨 Установка Latte Dock из AUR..."
sudo -u liveuser bash << 'EOFLATTE'
set -e
cd /tmp
yay -S --noconfirm --removemake --cleanafter latte-dock || echo "⚠️  Latte Dock не установлен"
cd /tmp
EOFLATTE

# Установка Calamares из AUR
echo "💿 Установка Calamares из AUR..."
sudo -u liveuser bash << 'EOFCALA'
set -e
cd /tmp
yay -S --noconfirm --removemake --cleanafter calamares || echo "⚠️  Calamares не установлен"
cd /tmp
EOFCALA

# Создание иконки установщика на рабочем столе
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/calamares.desktop << 'EOFDESKTOP'
[Desktop Entry]
Type=Application
Name=Install macOS Liquid Arch
Name[ru]=Установить macOS Liquid Arch
Comment=System Installer
Icon=system-software-install
Exec=sudo -E calamares
Terminal=false
Categories=System;
EOFDESKTOP

# Автозапуск Calamares при первом входе
mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/calamares-autostart.desktop << 'EOFAUTO'
[Desktop Entry]
Type=Application
Name=Install System
Exec=bash -c "sleep 5 && sudo -E calamares"
Hidden=false
NoDisplay=false
X-KDE-autostart-after=panel
X-KDE-autostart-phase=2
EOFAUTO

echo "✅ Latte Dock и Calamares установлены!"

# Установка тем из ZIP файлов
echo "🎨 Установка тем macOS из ZIP файлов..."
if [ -d /usr/share/320kgpenguin-themes ]; then
    chmod +x /usr/local/bin/install-themes.sh
    sudo -u liveuser bash << 'EOFTHEMES'
export HOME=/home/liveuser
export USER=liveuser
/usr/local/bin/install-themes.sh
EOFTHEMES
    echo "✅ Темы установлены!"
else
    echo "⚠️  Темы не найдены, пропускаем установку"
fi

# Установка тем macOS
echo "🎨 Установка тем macOS..."

# MacSonoma KDE theme
sudo -u liveuser bash << 'EOFTHEME'
set -e
yay -S --noconfirm --removemake --cleanafter macsonoma-kde-git || echo "⚠️  MacSonoma theme пропущена"
EOFTHEME

# WhiteSur GTK theme
sudo -u liveuser bash << 'EOFGTK'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-gtk-theme-git || echo "⚠️  WhiteSur GTK пропущена"
EOFGTK

# WhiteSur Icon theme
sudo -u liveuser bash << 'EOFICON'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-icon-theme-git || echo "⚠️  WhiteSur Icons пропущены"
EOFICON

# WhiteSur Cursors
sudo -u liveuser bash << 'EOFCURSOR'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-cursors-git || echo "⚠️  WhiteSur Cursors пропущены"
EOFCURSOR

# Albert Launcher
sudo -u liveuser bash << 'EOFALBERT'
set -e
yay -S --noconfirm --removemake --cleanafter albert || echo "⚠️  Albert пропущен"
EOFALBERT

# Lightly Application Style
sudo -u liveuser bash << 'EOFLIGHTLY'
set -e
yay -S --noconfirm --removemake --cleanafter lightly-qt || echo "⚠️  Lightly пропущен"
EOFLIGHTLY

echo "✅ Темы macOS установлены!"

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

# Применение настроек macOS для liveuser
echo "🍎 Применение настроек macOS..."
chmod +x /usr/local/bin/setup-macos-features.sh

# Запуск настройки от liveuser
sudo -u liveuser bash << 'EOFSETUP'
export HOME=/home/liveuser
export USER=liveuser
/usr/local/bin/setup-macos-features.sh
EOFSETUP

echo ""
echo "✅ Кастомизация завершена!"
echo ""
echo "🐧 320kgpenguin (macOS Liquid Arch) готов!"
echo ""
echo "👤 Учетные данные Live ISO:"
echo "  liveuser (без пароля, автологин)"
echo "  root (без пароля)"
echo "  sudo работает без пароля"
echo ""
echo "💿 Установка системы:"
echo "  Calamares запустится автоматически после загрузки"
echo "  Или запустите вручную: sudo calamares"
echo "  Или кликните иконку 'Install macOS Liquid Arch' на рабочем столе"
echo ""
echo "🎨 Темы установлены!"
echo "✨ Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
