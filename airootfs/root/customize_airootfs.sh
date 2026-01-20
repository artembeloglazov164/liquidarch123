#!/usr/bin/env bash
# Кастомизация macOS Arch

set -e -u

echo "Начало кастомизации macOS Arch"

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

# Простая установка yay из GitHub релиза
curl -L -o /tmp/yay_12.5.7_x86_64.tar.gz https://github.com/Jguer/yay/releases/download/v12.5.7/yay_12.5.7_x86_64.tar.gz
cd /tmp
tar -xzf yay_12.5.7_x86_64.tar.gz
install -Dm755 /tmp/yay_12.5.7_x86_64/yay /usr/bin/yay
rm -rf /tmp/yay_12.5.7_x86_64 /tmp/yay_12.5.7_x86_64.tar.gz

echo "yay установлен!"

# Создание скрипта для установки AUR пакетов ДО запуска KDE
echo "Создание скрипта первого запуска..."
cat > /usr/local/bin/first-boot-setup.sh << 'EOFFIRST'
#!/bin/bash
# Скрипт первого запуска - устанавливает AUR пакеты до загрузки KDE

MARKER="/var/lib/first-boot-done"

# Если уже выполнялось - пропустить
if [ -f "$MARKER" ]; then
    exit 0
fi

clear
echo "================================================================"
echo ""
echo "        macOS Arch"
echo ""
echo "        Первый запуск - установка компонентов"
echo ""
echo "================================================================"
echo ""
echo "Это займет ~10-15 минут. Пожалуйста, подождите..."
echo ""
echo "Что будет установлено:"
echo "  - Latte Dock (панель внизу)"
echo "  - Calamares (установщик системы)"
echo "  - Темы macOS (WhiteSur, MacSonoma)"
echo "  - Albert Launcher (Spotlight)"
echo ""
echo "Требуется интернет соединение"
echo ""
sleep 3

# Проверка интернета
echo "Проверка интернет соединения..."
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo ""
    echo "Нет интернет соединения!"
    echo ""
    echo "Пожалуйста:"
    echo "  1. Подключитесь к интернету"
    echo "  2. Перезагрузите систему"
    echo ""
    read -p "Нажмите Enter для продолжения без установки..."
    touch "$MARKER"
    exit 0
fi
echo "Интернет доступен"
echo ""

# Функция установки с обработкой ошибок
install_package() {
    local name=$1
    local package=$2
    echo ""
    echo "----------------------------------------------------------------"
    echo "Установка: $name"
    echo "----------------------------------------------------------------"
    if sudo -u liveuser yay -S --noconfirm --removemake --cleanafter "$package" 2>&1 | tee /tmp/install-$package.log; then
        echo "OK: $name установлен"
    else
        echo "WARN: Ошибка установки $name (пропущено)"
    fi
}

# Установка пакетов
install_package "Latte Dock" "latte-dock"
install_package "Calamares" "calamares"
install_package "MacSonoma Theme" "macsonoma-kde-git"
install_package "WhiteSur GTK Theme" "whitesur-gtk-theme-git"
install_package "WhiteSur Icons" "whitesur-icon-theme-git"
install_package "WhiteSur Cursors" "whitesur-cursors-git"
install_package "Albert Launcher" "albert"

# Очистка кэша
echo ""
echo "----------------------------------------------------------------"
echo "Очистка кэша..."
echo "----------------------------------------------------------------"
sudo -u liveuser yay -Sc --noconfirm || true
rm -rf /home/liveuser/.cache/yay

# Отметка о выполнении
touch "$MARKER"

echo ""
echo "================================================================"
echo ""
echo "        Установка завершена!"
echo ""
echo "        Запуск KDE Plasma через 5 секунд..."
echo ""
echo "================================================================"
echo ""
sleep 5

EOFFIRST
chmod +x /usr/local/bin/first-boot-setup.sh

# Создание systemd service для запуска перед SDDM
cat > /etc/systemd/system/first-boot-setup.service << 'EOFSERVICE'
[Unit]
Description=First Boot Setup - Install AUR packages
Before=display-manager.service
After=network-online.target
Wants=network-online.target
ConditionPathExists=!/var/lib/first-boot-done

[Service]
Type=oneshot
ExecStart=/usr/local/bin/first-boot-setup.sh
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes

[Install]
WantedBy=multi-user.target
EOFSERVICE

# Включение сервиса
systemctl enable first-boot-setup.service

# Создание иконки на рабочем столе для запуска Calamares
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/install-system.desktop << 'EOFDESKTOP'
[Desktop Entry]
Type=Application
Name=Install macOS Arch
Comment=Install system to disk
Icon=system-software-install
Exec=sudo calamares
Terminal=false
Categories=System;
EOFDESKTOP

echo "Сервис первого запуска создан!"

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

echo "Базовая настройка завершена!"

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
            "format": "macOS Arch"
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

# Создание /etc/os-release для macOS Arch
cat > /etc/os-release << 'EOF'
NAME="macOS Arch"
PRETTY_NAME="macOS Arch"
ID=macos-arch
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://github.com/320kgpenguin/macos-arch"
DOCUMENTATION_URL="https://github.com/320kgpenguin/macos-arch"
SUPPORT_URL="https://github.com/320kgpenguin/macos-arch/issues"
BUG_REPORT_URL="https://github.com/320kgpenguin/macos-arch/issues"
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
echo "macOS Arch готов!"
echo ""
echo "Учетные данные Live ISO:"
echo "  liveuser (без пароля, автологин)"
echo "  root (без пароля)"
echo "  sudo работает без пароля"
echo ""
echo "Первый запуск:"
echo "  AUR пакеты установятся автоматически ДО загрузки KDE"
echo "  Это займет ~10-15 минут"
echo "  После установки KDE запустится автоматически"
echo ""
echo "Что будет установлено из AUR:"
echo "  - Latte Dock (панель внизу)"
echo "  - Calamares (установщик)"
echo "  - Темы macOS (WhiteSur, MacSonoma, Albert)"
echo ""
echo "Требуется интернет соединение при первом запуске"
echo "Базовые темы установлены из ZIP файлов"
echo "Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
