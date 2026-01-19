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

# Создание скрипта для установки AUR пакетов после загрузки
echo "📝 Создание скрипта установки AUR пакетов..."
cat > /usr/local/bin/install-aur-packages.sh << 'EOFAUR'
#!/bin/bash
echo "� Установка компонентов macOS Liquid Arch"
echo "=========================================="
echo ""
echo "Это установит:"
echo "  • Latte Dock (панель внизу)"
echo "  • Calamares (установщик системы)"
echo "  • Темы macOS (WhiteSur, MacSonoma)"
echo "  • Albert Launcher (Spotlight)"
echo ""
echo "⏱️  Время установки: ~10-15 минут"
echo "🌐 Требуется интернет соединение"
echo ""
read -p "Нажмите Enter для продолжения..."

# Установка Latte Dock
echo ""
echo "📦 [1/7] Установка Latte Dock..."
yay -S --noconfirm --removemake --cleanafter latte-dock || echo "⚠️  Ошибка установки Latte Dock"

# Установка Calamares
echo ""
echo "💿 [2/7] Установка Calamares..."
yay -S --noconfirm --removemake --cleanafter calamares || echo "⚠️  Ошибка установки Calamares"

# Установка тем
echo ""
echo "🎨 [3/7] Установка MacSonoma theme..."
yay -S --noconfirm --removemake --cleanafter macsonoma-kde-git || echo "⚠️  Пропущено"

echo ""
echo "🎨 [4/7] Установка WhiteSur GTK theme..."
yay -S --noconfirm --removemake --cleanafter whitesur-gtk-theme-git || echo "⚠️  Пропущено"

echo ""
echo "🎨 [5/7] Установка WhiteSur Icons..."
yay -S --noconfirm --removemake --cleanafter whitesur-icon-theme-git || echo "⚠️  Пропущено"

echo ""
echo "🖱️  [6/7] Установка WhiteSur Cursors..."
yay -S --noconfirm --removemake --cleanafter whitesur-cursors-git || echo "⚠️  Пропущено"

echo ""
echo "🔍 [7/7] Установка Albert Launcher..."
yay -S --noconfirm --removemake --cleanafter albert || echo "⚠️  Пропущено"

# Очистка
echo ""
echo "🧹 Очистка кэша..."
yay -Sc --noconfirm || true

echo ""
echo "=========================================="
echo "✅ Установка завершена!"
echo ""
echo "Запуск Latte Dock..."
latte-dock &

echo ""
echo "Запуск Calamares установщика..."
sleep 2
sudo calamares
EOFAUR
chmod +x /usr/local/bin/install-aur-packages.sh

# Создание иконки на рабочем столе
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/install-system.desktop << 'EOFDESKTOP'
[Desktop Entry]
Type=Application
Name=Install macOS Liquid Arch
Name[ru]=Установить macOS Liquid Arch
Comment=Install Latte Dock, Calamares and start system installer
Comment[ru]=Установить Latte Dock, Calamares и запустить установщик системы
Icon=system-software-install
Exec=konsole --hold -e /usr/local/bin/install-aur-packages.sh
Terminal=false
Categories=System;
EOFDESKTOP

# Автозапуск установщика при первом входе
mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/install-prompt.desktop << 'EOFAUTO'
[Desktop Entry]
Type=Application
Name=Install Prompt
Exec=bash -c "sleep 10 && kdialog --title '🍎 320kgpenguin Installer' --yesno 'Добро пожаловать в 320kgpenguin (macOS Liquid Arch)!\n\nУстановить систему на компьютер?\n\nЭто установит:\n  • Latte Dock (панель внизу)\n  • Calamares (установщик системы)\n  • Темы macOS (WhiteSur, MacSonoma)\n  • Albert Launcher (Spotlight)\n\n⏱️  Время: ~10-15 минут\n🌐 Требуется интернет' && konsole --hold -e /usr/local/bin/install-aur-packages.sh"
Hidden=false
NoDisplay=false
X-KDE-autostart-after=panel
X-KDE-autostart-phase=2
EOFAUTO

echo "✅ Скрипт установки создан!"

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

echo "✅ Базовая настройка завершена!"

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
echo "  При первом входе появится диалог установки"
echo "  Или кликните иконку 'Install macOS Liquid Arch' на рабочем столе"
echo ""
echo "📦 Что будет установлено из AUR:"
echo "  • Latte Dock (панель внизу)"
echo "  • Calamares (установщик)"
echo "  • Темы macOS (WhiteSur, MacSonoma, Albert)"
echo ""
echo "⏱️  Время установки: ~10-15 минут"
echo "🌐 Требуется интернет соединение"
echo ""
echo "🎨 Базовые темы установлены из ZIP файлов"
echo "✨ Все настройки macOS применены"
echo ""
echo "=== Конец кастомизации ==="
