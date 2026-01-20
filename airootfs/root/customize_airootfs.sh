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

# Функция установки с обработкой ошибок и проверкой
install_package() {
    local name=$1
    local package=$2
    local optional=${3:-false}
    
    echo ""
    echo "----------------------------------------------------------------"
    echo "Установка: $name"
    echo "----------------------------------------------------------------"
    
    # Проверка, не установлен ли уже пакет
    if pacman -Qi "$package" &>/dev/null || pacman -Qi "${package%-git}" &>/dev/null; then
        echo "OK: $name уже установлен"
        return 0
    fi
    
    # Попытка установки с разрешением зависимостей
    if sudo -u liveuser yay -S --noconfirm --needed --removemake --cleanafter --answerdiff=None --answerclean=None --mflags "--nocheck --skippgpcheck" "$package" 2>&1 | tee /tmp/install-$package.log; then
        echo "OK: $name установлен"
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo "SKIP: $name пропущен (опциональный)"
        else
            echo "WARN: Ошибка установки $name"
            echo "Попытка установки без зависимостей..."
            # Попытка установки с игнорированием зависимостей
            if sudo -u liveuser yay -S --noconfirm --needed --nodeps --removemake --cleanafter --mflags "--nocheck --skippgpcheck" "$package" 2>&1 | tee -a /tmp/install-$package.log; then
                echo "OK: $name установлен (без зависимостей)"
                return 0
            else
                echo "FAIL: $name не установлен"
            fi
        fi
        return 1
    fi
}

# Обновление базы данных пакетов
echo "Обновление базы данных пакетов..."
sudo -u liveuser yay -Sy --noconfirm

# Установка пакетов из AUR (в правильном порядке)
echo ""
echo "================================================================"
echo "Установка пакетов из AUR..."
echo "================================================================"

# 1. Latte Dock (критичный)
install_package "Latte Dock" "latte-dock" false

# 2. Calamares (критичный)
install_package "Calamares" "calamares" false

# 3. WhiteSur Icons (опциональный)
install_package "WhiteSur Icons" "whitesur-icon-theme-git" true

# 4. WhiteSur Cursors (опциональный)
install_package "WhiteSur Cursors" "whitesur-cursors-git" true

# Проверка установленных пакетов
echo ""
echo "================================================================"
echo "Проверка установленных пакетов..."
echo "================================================================"

INSTALLED_COUNT=0
FAILED_PACKAGES=""

if pacman -Qi latte-dock &>/dev/null; then
    echo "✅ Latte Dock установлен"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
else
    echo "❌ Latte Dock НЕ установлен"
    FAILED_PACKAGES="$FAILED_PACKAGES latte-dock"
fi

if pacman -Qi calamares &>/dev/null; then
    echo "✅ Calamares установлен"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
else
    echo "❌ Calamares НЕ установлен"
    FAILED_PACKAGES="$FAILED_PACKAGES calamares"
fi

if pacman -Qi whitesur-icon-theme-git &>/dev/null; then
    echo "✅ WhiteSur Icons установлены"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
else
    echo "⚠️  WhiteSur Icons не установлены (опционально)"
fi

if pacman -Qi whitesur-cursors-git &>/dev/null; then
    echo "✅ WhiteSur Cursors установлены"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
else
    echo "⚠️  WhiteSur Cursors не установлены (опционально)"
fi

echo ""
echo "Установлено пакетов: $INSTALLED_COUNT"

if [ -n "$FAILED_PACKAGES" ]; then
    echo ""
    echo "⚠️  Не удалось установить критичные пакеты:$FAILED_PACKAGES"
    echo ""
    echo "Вы можете установить их вручную позже:"
    for pkg in $FAILED_PACKAGES; do
        echo "  yay -S $pkg"
    done
fi

# Очистка кэша
echo ""
echo "----------------------------------------------------------------"
echo "Очистка кэша..."
echo "----------------------------------------------------------------"
sudo -u liveuser yay -Sc --noconfirm || true
rm -rf /home/liveuser/.cache/yay

# Применение иконок и курсоров для liveuser
echo ""
echo "----------------------------------------------------------------"
echo "Применение тем..."
echo "----------------------------------------------------------------"
sudo -u liveuser bash << 'EOFAPPLY'
export HOME=/home/liveuser
export USER=liveuser

# Проверка установленных тем
ICONS_INSTALLED=false
CURSORS_INSTALLED=false

if pacman -Qi whitesur-icon-theme-git &>/dev/null; then
    ICONS_INSTALLED=true
fi

if pacman -Qi whitesur-cursors-git &>/dev/null; then
    CURSORS_INSTALLED=true
fi

# Применение иконок если установлены
if [ "$ICONS_INSTALLED" = true ]; then
    echo "Применение иконок WhiteSur..."
    if [ -f "$HOME/.config/kdeglobals" ]; then
        sed -i '/\[Icons\]/,/^$/d' "$HOME/.config/kdeglobals"
        echo "" >> "$HOME/.config/kdeglobals"
        echo "[Icons]" >> "$HOME/.config/kdeglobals"
        echo "Theme=WhiteSur-dark" >> "$HOME/.config/kdeglobals"
    else
        mkdir -p "$HOME/.config"
        cat > "$HOME/.config/kdeglobals" << 'EOF'
[Icons]
Theme=WhiteSur-dark
EOF
    fi
    echo "✅ Иконки WhiteSur применены"
else
    echo "⚠️  Иконки WhiteSur не установлены, используются стандартные"
fi

# Применение курсоров если установлены
if [ "$CURSORS_INSTALLED" = true ]; then
    echo "Применение курсоров WhiteSur..."
    mkdir -p "$HOME/.config"
    cat > "$HOME/.config/kcminputrc" << 'EOF'
[Mouse]
cursorTheme=WhiteSur-cursors
EOF
    echo "✅ Курсоры WhiteSur применены"
else
    echo "⚠️  Курсоры WhiteSur не установлены, используются стандартные"
fi

EOFAPPLY

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
echo "  - WhiteSur Icons & Cursors"
echo ""
echo "Требуется интернет соединение при первом запуске"
echo "Тема MacVentura установлена"
echo "Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
