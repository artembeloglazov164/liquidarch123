#!/usr/bin/env bash
# Кастомизация 320kgpenguin (macOS Liquid Arch)
# ПОЛНАЯ ВЕРСИЯ - все устанавливается во время сборки ISO

set -e -u

echo "Начало кастомизации 320kgpenguin (ПОЛНАЯ ВЕРСИЯ)"

# Создание пользователя liveuser
echo "Создание пользователя liveuser..."
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash liveuser || true
passwd -d liveuser || true
passwd -d root || true

echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Включение служб
echo "Включение служб..."
systemctl enable NetworkManager
systemctl enable sddm
systemctl enable bluetooth || true
systemctl enable cups || true

# Настройка SDDM
echo "Настройка SDDM..."
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

# Установка yay
echo "Установка yay..."
cd /tmp

# Исправление для работы в chroot
export PKGDEST=/tmp/packages
mkdir -p /tmp/packages
chown -R liveuser:liveuser /tmp/packages
chmod 755 /tmp/packages

# Очистка перед установкой
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true

sudo -u liveuser bash << 'EOFYAY'
set -e
export PKGDEST=/tmp/packages
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm --skippgpcheck
cd /tmp
rm -rf yay-bin
EOFYAY

echo "yay установлен!"

# Очистка после установки yay
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true

# Установка Latte Dock из AUR
echo "Установка Latte Dock из AUR..."
sudo -u liveuser bash << 'EOFLATTE'
set -e
yay -S --noconfirm --removemake --cleanafter latte-dock
yay -Sc --noconfirm
EOFLATTE
# Очистка кэша
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true
echo "Latte Dock установлен!"

# Установка Calamares из AUR
echo "Установка Calamares из AUR..."
sudo -u liveuser bash << 'EOFCALA'
set -e
yay -S --noconfirm --removemake --cleanafter calamares
yay -Sc --noconfirm
EOFCALA
# Очистка кэша
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true
echo "Calamares установлен!"

# Установка тем macOS из AUR
echo "Установка тем macOS из AUR..."

# MacSonoma KDE theme
sudo -u liveuser bash << 'EOFTHEME'
set -e
yay -S --noconfirm --removemake --cleanafter macsonoma-kde-git || echo "MacSonoma theme пропущена"
yay -Sc --noconfirm
EOFTHEME
pacman -Scc --noconfirm || true

# WhiteSur GTK theme
sudo -u liveuser bash << 'EOFGTK'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-gtk-theme-git || echo "WhiteSur GTK пропущена"
yay -Sc --noconfirm
EOFGTK
pacman -Scc --noconfirm || true

# WhiteSur Icon theme
sudo -u liveuser bash << 'EOFICON'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-icon-theme-git || echo "WhiteSur Icons пропущены"
yay -Sc --noconfirm
EOFICON
pacman -Scc --noconfirm || true

# WhiteSur Cursors
sudo -u liveuser bash << 'EOFCURSOR'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-cursors-git || echo "WhiteSur Cursors пропущены"
yay -Sc --noconfirm
EOFCURSOR
pacman -Scc --noconfirm || true

# Albert Launcher
sudo -u liveuser bash << 'EOFALBERT'
set -e
yay -S --noconfirm --removemake --cleanafter albert || echo "Albert пропущен"
yay -Sc --noconfirm
EOFALBERT
pacman -Scc --noconfirm || true

# Lightly Application Style
sudo -u liveuser bash << 'EOFLIGHTLY'
set -e
yay -S --noconfirm --removemake --cleanafter lightly-qt || echo "Lightly пропущен"
yay -Sc --noconfirm
EOFLIGHTLY
pacman -Scc --noconfirm || true

echo "Темы macOS установлены!"

# Финальная очистка кэша AUR
echo "Финальная очистка кэша..."
sudo -u liveuser yay -Sc --noconfirm || true
rm -rf /home/liveuser/.cache/yay
rm -rf /var/cache/pacman/pkg/*
rm -rf /tmp/*

# Создание иконки на рабочем столе для запуска Calamares
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/install-system.desktop << 'EOFDESKTOP'
[Desktop Entry]
Type=Application
Name=Install macOS Liquid Arch
Name[ru]=Установить macOS Liquid Arch
Comment=Install system to disk
Comment[ru]=Установить систему на диск
Icon=system-software-install
Exec=sudo calamares
Terminal=false
Categories=System;
EOFDESKTOP

# Автозапуск Calamares при первом входе
mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/calamares-autostart.desktop << 'EOFAUTO'
[Desktop Entry]
Type=Application
Name=Install System
Exec=bash -c "sleep 10 && sudo calamares"
Hidden=false
NoDisplay=false
X-KDE-autostart-after=panel
X-KDE-autostart-phase=2
EOFAUTO

echo "Calamares настроен для автозапуска!"

# Установка тем из ZIP файлов
echo "Установка тем macOS из ZIP файлов..."
if [ -d /usr/share/320kgpenguin-themes ]; then
    chmod +x /usr/local/bin/install-themes.sh
    sudo -u liveuser bash << 'EOFTHEMES'
export HOME=/home/liveuser
export USER=liveuser
/usr/local/bin/install-themes.sh
EOFTHEMES
    echo "Темы установлены!"
else
    echo "Темы не найдены, пропускаем установку"
fi

# Копирование конфигов для всех пользователей
echo "Копирование конфигураций..."
cp -r /etc/skel/.config /home/liveuser/ 2>/dev/null || true
cp -r /etc/skel/.local /home/liveuser/ 2>/dev/null || true
chown -R liveuser:liveuser /home/liveuser 2>/dev/null || true

# Настройка fastfetch
echo "Настройка fastfetch..."
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
            "format": "320kgpenguin (macOS Liquid Arch)"
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
echo "Настройка GRUB темы..."
chmod +x /usr/local/bin/install-grub-theme.sh
/usr/local/bin/install-grub-theme.sh || echo "GRUB тема не установлена"

# Применение настроек macOS для liveuser
echo "Применение настроек macOS..."
chmod +x /usr/local/bin/setup-macos-features.sh

# Запуск настройки от liveuser
sudo -u liveuser bash << 'EOFSETUP'
export HOME=/home/liveuser
export USER=liveuser
/usr/local/bin/setup-macos-features.sh
EOFSETUP

echo ""
echo "Кастомизация завершена!"
echo ""
echo "320kgpenguin (macOS Liquid Arch) готов!"
echo ""
echo "Учетные данные Live ISO:"
echo "  liveuser (без пароля, автологин)"
echo "  root (без пароля)"
echo "  sudo работает без пароля"
echo ""
echo "Установка системы:"
echo "  Calamares запустится автоматически после загрузки KDE"
echo "  Или кликните иконку 'Install macOS Liquid Arch' на рабочем столе"
echo ""
echo "ВСЕ КОМПОНЕНТЫ УЖЕ УСТАНОВЛЕНЫ:"
echo "  - Latte Dock (панель внизу)"
echo "  - Calamares (установщик)"
echo "  - Темы macOS (WhiteSur, MacSonoma, Albert)"
echo ""
echo "Базовые темы установлены из ZIP файлов"
echo "Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
