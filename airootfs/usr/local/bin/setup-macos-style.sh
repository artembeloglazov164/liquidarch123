#!/bin/bash
# Настройка GNOME в стиле macOS

echo "🍎 Настройка macOS стиля для GNOME..."

# Установка темы
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# Кнопки окон слева (как в macOS)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Dock внизу
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true

# Эффект увеличения иконок
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

# 4 рабочих стола
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.mutter dynamic-workspaces false

# Горячие клавиши в стиле macOS
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>']"

# Шрифты
gsettings set org.gnome.desktop.interface font-name 'Roboto 10'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Roboto Mono 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 10'

# Анимации
gsettings set org.gnome.desktop.interface enable-animations true

# Включение расширений
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

echo "✅ Настройка завершена!"
echo ""
echo "Горячие клавиши:"
echo "  Super - Activities (Launchpad)"
echo "  Super+Q - Закрыть окно"
echo "  Super+M - Свернуть окно"
echo "  Super+Tab - Переключение окон"
echo "  Ctrl+←/→ - Переключение рабочих столов"
