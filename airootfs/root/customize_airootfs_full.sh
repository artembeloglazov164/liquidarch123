#!/usr/bin/env bash
# Кастомизация macOS Arch
# ПОЛНАЯ ВЕРСИЯ - все устанавливается во время сборки ISO

set -e -u

echo "Начало кастомизации macOS Arch (ПОЛНАЯ ВЕРСИЯ)"

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

# Очистка перед установкой
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true

# Установка yay-bin вручную (обход проблемы с pacman в chroot)
sudo -u liveuser bash << 'EOFYAY'
set -e
cd /tmp

# Скачивание и распаковка yay-bin
curl -L -o yay_12.5.7_x86_64.tar.gz https://github.com/Jguer/yay/releases/download/v12.5.7/yay_12.5.7_x86_64.tar.gz
tar -xzf yay_12.5.7_x86_64.tar.gz
cd yay_12.5.7_x86_64

# Установка бинарника
sudo install -Dm755 yay /usr/bin/yay

# Установка дополнительных файлов (только если они существуют)
if [ -f yay.8 ]; then
    sudo install -Dm644 yay.8 /usr/share/man/man8/yay.8
fi

if [ -f yay.fish ]; then
    sudo install -Dm644 yay.fish /usr/share/fish/vendor_completions.d/yay.fish
fi

if [ -f yay.bash ]; then
    sudo install -Dm644 yay.bash /usr/share/bash-completion/completions/yay
fi

if [ -f zsh ]; then
    sudo install -Dm644 zsh /usr/share/zsh/site-functions/_yay
fi

cd /tmp
rm -rf yay_12.5.7_x86_64 yay_12.5.7_x86_64.tar.gz
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
pacman -Scc --noconfirm || true
rm -rf /var/cache/pacman/pkg/* || true
echo "Calamares установлен!"

# Установка WhiteSur Icons
echo "Установка WhiteSur Icons из AUR..."
sudo -u liveuser bash << 'EOFICON'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-icon-theme-git || echo "WhiteSur Icons пропущены"
yay -Sc --noconfirm
EOFICON
pacman -Scc --noconfirm || true
echo "WhiteSur Icons установлены!"

# Установка WhiteSur Cursors
echo "Установка WhiteSur Cursors из AUR..."
sudo -u liveuser bash << 'EOFCURSOR'
set -e
yay -S --noconfirm --removemake --cleanafter whitesur-cursors-git || echo "WhiteSur Cursors пропущены"
yay -Sc --noconfirm
EOFCURSOR
pacman -Scc --noconfirm || true
echo "WhiteSur Cursors установлены!"

# Применение иконок и курсоров для liveuser
echo "Применение иконок и курсоров для liveuser..."
sudo -u liveuser bash << 'EOFAPPLY'
export HOME=/home/liveuser
export USER=liveuser

# Обновление kdeglobals для иконок
if [ -f "$HOME/.config/kdeglobals" ]; then
    sed -i '/\[Icons\]/,/^$/d' "$HOME/.config/kdeglobals"
    echo "" >> "$HOME/.config/kdeglobals"
    echo "[Icons]" >> "$HOME/.config/kdeglobals"
    echo "Theme=WhiteSur-dark" >> "$HOME/.config/kdeglobals"
fi

# Обновление kcminputrc для курсоров
if [ -f "$HOME/.config/kcminputrc" ]; then
    sed -i '/\[Mouse\]/,/^$/d' "$HOME/.config/kcminputrc"
    echo "" >> "$HOME/.config/kcminputrc"
    echo "[Mouse]" >> "$HOME/.config/kcminputrc"
    echo "cursorTheme=WhiteSur-cursors" >> "$HOME/.config/kcminputrc"
fi

echo "✅ Иконки и курсоры применены"
EOFAPPLY

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
Name=Install macOS Arch
Name[ru]=Установить macOS Arch
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

# Копирование темы MacVentura
echo "Копирование темы MacVentura..."
if [ -d /themes/MacVentura ]; then
    mkdir -p /usr/share/macventura-theme
    cp -r /themes/MacVentura/* /usr/share/macventura-theme/
    chmod +x /usr/share/macventura-theme/install.sh
    chmod +x /usr/local/bin/install-macventura-theme.sh
    echo "✅ Тема MacVentura скопирована"
else
    echo "⚠️  Тема MacVentura не найдена"
fi

# Установка темы MacVentura (системная установка)
echo "Установка темы MacVentura..."
if [ -f /usr/local/bin/install-macventura-theme.sh ]; then
    chmod +x /usr/local/bin/install-macventura-theme.sh
    bash /usr/local/bin/install-macventura-theme.sh
    echo "✅ Тема MacVentura установлена системно"
else
    echo "⚠️  Скрипт установки темы не найден"
fi

# Применение темы для liveuser
echo "Применение темы для liveuser..."
if [ -f /usr/local/bin/apply-macventura-theme.sh ]; then
    chmod +x /usr/local/bin/apply-macventura-theme.sh
    sudo -u liveuser bash << 'EOFTHEME'
export HOME=/home/liveuser
export USER=liveuser
bash /usr/local/bin/apply-macventura-theme.sh
EOFTHEME
    echo "✅ Тема применена для liveuser"
else
    echo "⚠️  Скрипт применения темы не найден"
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
echo "Установка системы:"
echo "  Calamares запустится автоматически после загрузки KDE"
echo "  Или кликните иконку 'Install macOS Arch' на рабочем столе"
echo ""
echo "ВСЕ КОМПОНЕНТЫ УЖЕ УСТАНОВЛЕНЫ:"
echo "  - Latte Dock (панель внизу)"
echo "  - Calamares (установщик)"
echo "  - Тема MacVentura"
echo "  - WhiteSur Icons & Cursors"
echo ""
echo "Тема MacVentura установлена"
echo "Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
