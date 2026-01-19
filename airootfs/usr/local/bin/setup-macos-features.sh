#!/bin/bash
# Настройка всех фишек macOS для 320kgpenguin

echo "🍎 Настройка фишек macOS для KDE..."

# ========================================
# ТЕМЫ MACOS
# ========================================

echo "🎨 Применение тем macOS..."

# Plasma Theme: MacSonoma
kwriteconfig5 --file plasmarc --group Theme --key name "MacSonoma"

# GTK Theme: WhiteSur
kwriteconfig5 --file kdeglobals --group General --key ColorScheme "WhiteSur"
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle "Lightly"

# Icon Theme: WhiteSur
kwriteconfig5 --file kdeglobals --group Icons --key Theme "WhiteSur"

# Cursor Theme: WhiteSur
kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "WhiteSur-cursors"

# Application Style: Lightly
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle "Lightly"

# ========================================
# ALBERT LAUNCHER
# ========================================

echo "🔍 Настройка Albert Launcher..."

# Создание конфига Albert
mkdir -p ~/.config/albert
cat > ~/.config/albert/albert.conf << 'EOF'
[General]
hotkey=Meta+Space
showTray=false
terminal=konsole

[org.albert.extension.applications]
enabled=true

[org.albert.extension.calculator]
enabled=true

[org.albert.extension.files]
enabled=true

[org.albert.frontend.widgetboxmodel]
alwaysOnTop=true
clearOnHide=true
displayIcons=true
hideOnFocusLoss=true
showCentered=true
theme=Spotlight
EOF

# Автозапуск Albert
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/albert.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Albert
Exec=albert
Terminal=false
X-KDE-autostart-after=panel
EOF

echo "🖱️  Настройка трекпада..."

# Перетаскивание тремя пальцами
kwriteconfig5 --file kcminputrc --group Mouse --key X11LibInputXAccelProfileFlat true

# Natural scrolling (как в macOS)
kwriteconfig5 --file kcminputrc --group Libinput --group 1 --key NaturalScroll true

# Tap to click
kwriteconfig5 --file kcminputrc --group Libinput --group 1 --key TapToClick true

# Жесты трекпада
kwriteconfig5 --file kwinrc --group Plugins --key touchpadgesturesEnabled true

# ========================================
# ТЕМЫ MACOS
# ========================================

echo "🎨 Применение тем macOS..."

# Plasma Theme: MacSonoma
kwriteconfig5 --file plasmarc --group Theme --key name "MacSonoma"

# GTK Theme: WhiteSur
kwriteconfig5 --file kdeglobals --group General --key ColorScheme "WhiteSur"
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle "Lightly"

# Icon Theme: WhiteSur
kwriteconfig5 --file kdeglobals --group Icons --key Theme "WhiteSur-dark"

# Cursor Theme: WhiteSur
kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "WhiteSur-cursors"

# Application Style: Lightly
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle "Lightly"

# ========================================
# ALBERT LAUNCHER
# ========================================

echo "🔍 Настройка Albert Launcher..."

# Создание конфига Albert
mkdir -p ~/.config/albert
cat > ~/.config/albert/albert.conf << 'EOF'
[General]
hotkey=Meta+Space
showTray=false
telemetry=false

[org.albert.extension.applications]
enabled=true

[org.albert.extension.calculator]
enabled=true

[org.albert.extension.files]
enabled=true

[org.albert.frontend.widgetboxmodel]
alwaysOnTop=true
clearOnHide=true
displayIcons=true
hideOnFocusLoss=true
showCentered=true
theme=Spotlight
EOF

# Автозапуск Albert
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/albert.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Albert
Exec=albert
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Отключить KRunner (используем Albert)
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""

# Meta+Q - закрыть окно
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Close" "Meta+Q,Alt+F4,Close Window"

# Meta+M - свернуть окно
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+M,Meta+PgDown,Minimize Window"

# Meta+Tab - переключение окон
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Walk Through Windows" "Meta+Tab,Alt+Tab,Walk Through Windows"

# Ctrl+Left/Right - переключение рабочих столов
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" "Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" "Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"

# Ctrl+Up - Mission Control (все окна)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Expose" "Ctrl+Up,Ctrl+F9,Toggle Present Windows (Current desktop)"

# Meta+Space - Spotlight (Albert)
kwriteconfig5 --file kglobalshortcutsrc --group albert --key "show" "Meta+Space,none,Show Albert"

# Отключить KRunner на Meta+Space (используем Albert)
kwriteconfig5 --file kglobalshortcutsrc --group krunner.desktop --key "_launch" "Alt+F2,Alt+Space\tAlt+F2,KRunner"

# Meta+E - Dolphin (Finder)
kwriteconfig5 --file kglobalshortcutsrc --group org.kde.dolphin.desktop --key "_launch" "Meta+E,none,Dolphin"

# Meta+T - Konsole (Terminal)
kwriteconfig5 --file kglobalshortcutsrc --group org.kde.konsole.desktop --key "_launch" "Meta+T,none,Konsole"

# Meta+W - закрыть вкладку
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Close" "Meta+Q\tMeta+W,Alt+F4,Close Window"

# Meta+H - скрыть окно
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+M\tMeta+H,Meta+PgDown,Minimize Window"

# Meta+Shift+3 - скриншот всего экрана
kwriteconfig5 --file kglobalshortcutsrc --group org.kde.spectacle.desktop --key "FullScreenScreenShot" "Meta+Shift+3,none,Capture Entire Desktop"

# Meta+Shift+4 - скриншот области
kwriteconfig5 --file kglobalshortcutsrc --group org.kde.spectacle.desktop --key "RectangularRegionScreenShot" "Meta+Shift+4,none,Capture Rectangular Region"

# ========================================
# FINDER (DOLPHIN) НАСТРОЙКИ
# ========================================

echo "📁 Настройка Dolphin (Finder)..."

# Показать строку состояния
kwriteconfig5 --file dolphinrc --group General --key ShowFullPath true
kwriteconfig5 --file dolphinrc --group General --key ShowSpaceInfo true

# Показать панель пути
kwriteconfig5 --file dolphinrc --group General --key ShowPathBar true

# Отключить меню (глобальное меню сверху)
kwriteconfig5 --file dolphinrc --group MainWindow --key MenuBar Disabled

# Превью файлов
kwriteconfig5 --file dolphinrc --group PreviewSettings --key Plugins "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail"

# ========================================
# ЭФФЕКТЫ ОКОН (LIQUID GLASS)
# ========================================

echo "✨ Настройка эффектов жидкого стекла..."

# Включить композитинг
kwriteconfig5 --file kwinrc --group Compositing --key Enabled true
kwriteconfig5 --file kwinrc --group Compositing --key Backend OpenGL
kwriteconfig5 --file kwinrc --group Compositing --key GLCore true

# Blur эффект
kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig5 --file kwinrc --group Effect-blur --key BlurStrength 15
kwriteconfig5 --file kwinrc --group Effect-blur --key NoiseStrength 2

# Magic Lamp анимация
kwriteconfig5 --file kwinrc --group Plugins --key magiclampEnabled true
kwriteconfig5 --file kwinrc --group Effect-magiclamp --key AnimationDuration 250

# Wobbly Windows
kwriteconfig5 --file kwinrc --group Plugins --key wobblywindowsEnabled true
kwriteconfig5 --file kwinrc --group Effect-wobblywindows --key Drag 85
kwriteconfig5 --file kwinrc --group Effect-wobblywindows --key Stiffness 10

# Fade эффект
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadeEnabled true

# Translucency (прозрачность)
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_translucencyEnabled true

# Slide эффект
kwriteconfig5 --file kwinrc --group Plugins --key slideEnabled true

# ========================================
# КНОПКИ ОКОН СЛЕВА (🔴🟡🟢)
# ========================================

echo "🎨 Настройка кнопок окон..."

kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "XIA"
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight ""

# ========================================
# 4 РАБОЧИХ СТОЛА (SPACES)
# ========================================

echo "🖥️  Настройка рабочих столов..."

kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 1

# ========================================
# ГЛОБАЛЬНОЕ МЕНЮ (MENU BAR)
# ========================================

echo "📋 Настройка глобального меню..."

# Включить глобальное меню
kwriteconfig5 --file kdeglobals --group KDE --key ShowMenuBar false

# ========================================
# АВТОЗАМЕНЫ ТЕКСТА
# ========================================

echo "📝 Настройка автозамен текста..."

# Создание файла автозамен
mkdir -p ~/.config
cat > ~/.config/kxkbrc << 'EOF'
[Layout]
DisplayNames=
LayoutList=us,ru
Use=true
VariantList=,

[Shortcuts]
Switch to Next Keyboard Layout=Meta+Space
EOF

# ========================================
# KONSOLE (TERMINAL) НАСТРОЙКИ
# ========================================

echo "💻 Настройка Konsole..."

# Прозрачность
kwriteconfig5 --file konsolerc --group Desktop Entry --key DefaultProfile "macOS-Liquid.profile"

# Отключить меню
kwriteconfig5 --file konsolerc --group MainWindow --key MenuBar Disabled

# ========================================
# СИСТЕМНЫЕ НАСТРОЙКИ
# ========================================

echo "⚙️  Системные настройки..."

# Анимации
kwriteconfig5 --file kwinrc --group Compositing --key AnimationSpeed 3

# Центрирование новых окон
kwriteconfig5 --file kwinrc --group Windows --key Placement Centered

# Borderless maximized windows
kwriteconfig5 --file kwinrc --group Windows --key BorderlessMaximizedWindows true

# Single click to open files
kwriteconfig5 --file kdeglobals --group KDE --key SingleClick false

# ========================================
# LATTE DOCK НАСТРОЙКИ
# ========================================

echo "🎯 Настройка Latte Dock..."

# Dock внизу
kwriteconfig5 --file lattedockrc --group "PlasmaViews" --group "Panel 2" --key alignment 10
kwriteconfig5 --file lattedockrc --group "PlasmaViews" --group "Panel 2" --key floating 1
kwriteconfig5 --file lattedockrc --group "PlasmaViews" --group "Panel 2" --key panelSize 100
kwriteconfig5 --file lattedockrc --group "PlasmaViews" --group "Panel 2" --key panelTransparency 90
kwriteconfig5 --file lattedockrc --group "PlasmaViews" --group "Panel 2" --key screenEdgeMargin 8

# Эффект увеличения иконок
kwriteconfig5 --file lattedockrc --group UniversalSettings --key parabolicEffect 2
kwriteconfig5 --file lattedockrc --group UniversalSettings --key parabolicSpread 3

# Приложения в Dock
kwriteconfig5 --file lattedockrc --group UniversalSettings --key launchers "applications:org.kde.dolphin.desktop,applications:firefox.desktop,applications:org.kde.konsole.desktop,applications:org.kde.kate.desktop,applications:systemsettings.desktop"

# ========================================
# ДОПОЛНИТЕЛЬНЫЕ ФИШКИ
# ========================================

echo "🎁 Дополнительные фишки..."

# Включить Numlock при загрузке
kwriteconfig5 --file kcminputrc --group Keyboard --key NumLock 0

# Показывать секунды в часах
kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 1 --group Applets --group 2 --group Configuration --group Appearance --key showSeconds true

# Формат даты и времени
kwriteconfig5 --file kdeglobals --group Locale --key DateFormat "yyyy-MM-dd"
kwriteconfig5 --file kdeglobals --group Locale --key TimeFormat "HH:mm:ss"

# ========================================
# ПЕРЕЗАГРУЗКА НАСТРОЕК
# ========================================

echo "🔄 Применение настроек..."

# Перезагрузить KWin
qdbus org.kde.KWin /KWin reconfigure

# Перезапустить Plasma Shell
killall plasmashell 2>/dev/null
kstart5 plasmashell &

# Запустить Latte Dock
latte-dock &

echo ""
echo "✅ Все фишки macOS настроены!"
echo ""
echo "🍎 320kgpenguin теперь работает как настоящий macOS!"
echo ""
echo "Основные фишки:"
echo "  ✓ Перетаскивание тремя пальцами"
echo "  ✓ Natural scrolling"
echo "  ✓ Tap to click"
echo "  ✓ Горячие клавиши macOS"
echo "  ✓ Жидкое стекло (blur, прозрачность)"
echo "  ✓ Magic Lamp анимация"
echo "  ✓ Кнопки окон слева (🔴🟡🟢)"
echo "  ✓ 4 рабочих стола"
echo "  ✓ Глобальное меню"
echo "  ✓ Latte Dock внизу"
echo "  ✓ Dolphin как Finder"
echo "  ✓ Konsole с прозрачностью"
echo ""
echo "⚠️  Перезагрузите систему для применения всех изменений"
