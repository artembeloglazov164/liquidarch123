#!/bin/bash
# Настройка GNOME в стиле macOS

echo "🍎 Настройка macOS стиля для GNOME..."

# Установка темы
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Кнопки окон слева (как в macOS)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Настройка Dash to Dock (встроенное расширение)
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.3
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true

# 4 рабочих стола
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.mutter dynamic-workspaces false

# Горячие клавиши в стиле macOS
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"

# Шрифты
gsettings set org.gnome.desktop.interface font-name 'Roboto 10'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Roboto Mono 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 10'

# Анимации
gsettings set org.gnome.desktop.interface enable-animations true

# Поведение окон
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter attach-modal-dialogs true

# Включение встроенных расширений
gnome-extensions enable dash-to-dock@micxgx.gmail.com || true
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com || true

# Установка Blur My Shell
echo "📦 Установка Blur My Shell..."
cd /tmp
git clone https://github.com/aunetx/blur-my-shell 2>/dev/null || true
if [ -d "blur-my-shell" ]; then
    cd blur-my-shell
    make install 2>/dev/null || true
    cd ..
    rm -rf blur-my-shell
fi

# Включение Blur My Shell
gnome-extensions enable blur-my-shell@aunetx.github.io 2>/dev/null || true

# Настройка Blur My Shell
echo "🎨 Настройка прозрачности и blur эффектов..."
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel brightness 0.6 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel sigma 30 2>/dev/null || true

gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30 2>/dev/null || true

gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview brightness 0.6 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview sigma 30 2>/dev/null || true

# Настройка файлового менеджера (Nautilus как Finder)
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences show-hidden-files false
gsettings set org.gnome.nautilus.list-view use-tree-view true

# Настройка терминала с прозрачностью
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")
if [ -n "$PROFILE" ]; then
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-transparent-background true
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ background-transparency-percent 10
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ background-color '#1e1e2e'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ foreground-color '#cdd6f4'
fi

echo "✅ Настройка завершена!"
echo ""
echo "🍎 macOS Liquid Arch готов к использованию!"
echo ""
echo "Установленные расширения:"
echo "  ✓ Dash to Dock - док панель внизу"
echo "  ✓ Blur My Shell - эффект размытия"
echo "  ✓ AppIndicator - индикаторы приложений"
echo ""
echo "Горячие клавиши:"
echo "  Super - Activities (Launchpad)"
echo "  Super+A - Приложения"
echo "  Super+Q - Закрыть окно"
echo "  Super+M - Свернуть окно"
echo "  Super+D - Показать рабочий стол"
echo "  Super+Tab - Переключение окон"
echo "  Ctrl+←/→ - Переключение рабочих столов"
echo ""
echo "Дополнительные расширения можно установить через:"
echo "  https://extensions.gnome.org"
echo ""
echo "⚠️  Перезагрузите систему для применения всех изменений"




