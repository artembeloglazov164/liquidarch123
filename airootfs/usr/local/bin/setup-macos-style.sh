#!/bin/bash
# Настройка GNOME в стиле macOS

echo "🍎 Настройка macOS стиля для GNOME..."

# Установка темы Reversal
gsettings set org.gnome.desktop.interface gtk-theme 'Reversal'
gsettings set org.gnome.desktop.wm.preferences theme 'Reversal'
gsettings set org.gnome.desktop.interface icon-theme 'Reversal'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Кнопки окон слева (как в macOS)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Настройка Dash to Dock (Dock внизу как в macOS)
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

# Включение расширений
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable bluetooth-battery-meter@maniacx.github.com
gnome-extensions enable privacy-menu@stuarthayhurst
gnome-extensions enable Vitals@CoreCoding.com
gnome-extensions enable clipboard-indicator@tudmotu.com
gnome-extensions enable ding@rastersoft.com
gnome-extensions enable kimpanel@kde.org
gnome-extensions enable mediacontrols@cliffniff.github.com
gnome-extensions enable openbar@neuromorph
gnome-extensions enable weatheroclock@CleoMenezesJr.github.io
gnome-extensions enable whoami@megh.sh

# Установка Blur My Shell (если еще не установлено)
if ! gnome-extensions list | grep -q "blur-my-shell"; then
    echo "📦 Установка Blur My Shell..."
    cd /tmp
    git clone https://github.com/aunetx/blur-my-shell
    cd blur-my-shell
    make install
    cd ..
    rm -rf blur-my-shell
fi

# Включение Blur My Shell
gnome-extensions enable blur-my-shell@aunetx.github.io || echo "⚠️  Blur My Shell будет доступен после перезагрузки"

# Настройка Blur My Shell (если установлено)
if gnome-extensions list | grep -q "blur-my-shell"; then
    echo "🎨 Настройка Blur My Shell..."
    
    # Включить blur для всех компонентов
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel sigma 30
    
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0
    
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview sigma 30
    
    gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder sigma 30
    
    gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur true
    gsettings set org.gnome.shell.extensions.blur-my-shell.window-list brightness 0.6
    gsettings set org.gnome.shell.extensions.blur-my-shell.window-list sigma 30
fi

# Настройка файлового менеджера (Nautilus как Finder)
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences show-hidden-files false
gsettings set org.gnome.nautilus.list-view use-tree-view true

# Настройка терминала с прозрачностью
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-transparent-background true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ background-transparency-percent 10
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ background-color '#1e1e2e'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ foreground-color '#cdd6f4'

echo "✅ Настройка завершена!"
echo ""
echo "🍎 macOS Liquid Arch готов к использованию!"
echo ""
echo "Установленные расширения:"
echo "  ✓ Dash to Dock - док панель внизу"
echo "  ✓ Blur My Shell - эффект размытия"
echo "  ✓ AppIndicator - индикаторы приложений"
echo "  ✓ Bluetooth Battery - уровень батареи Bluetooth"
echo "  ✓ Privacy Menu - быстрый доступ к настройкам приватности"
echo "  ✓ Vitals - мониторинг системы"
echo "  ✓ Clipboard Indicator - история буфера обмена"
echo "  ✓ Media Controls - управление медиа"
echo "  ✓ Weather O'Clock - погода и часы"
echo "  ✓ WhoAmI - информация о пользователе"
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
echo "⚠️  Если некоторые расширения не работают, перезагрузите систему"



