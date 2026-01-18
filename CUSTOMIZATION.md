# 🎨 Кастомизация macOS Liquid Arch

## Изменение темы

### Kvantum темы

```bash
# Установка дополнительных тем
yay -S kvantum-theme-materia
yay -S kvantum-theme-adapta

# Запуск менеджера тем
kvantummanager
```

### Цветовые схемы

Файл: `~/.config/kdeglobals`

Измените секцию `[WM]` для настройки цветов окон.

## Настройка Latte Dock

### Изменение размера

1. Правый клик на Latte Dock
2. Edit Dock → Appearance
3. Измените Size (рекомендуется 56-64)

### Добавление приложений

Просто перетащите иконку из меню приложений на док.

### Эффект увеличения

В настройках Latte Dock:
- Parabolic Effect: 2-3
- Zoom Factor: 1.5-2.0

## Настройка KWin эффектов

### Magic Lamp

```bash
kwriteconfig5 --file kwinrc --group Plugins --key magiclampEnabled true
kwriteconfig5 --file kwinrc --group Effect-magiclamp --key AnimationDuration 250
qdbus org.kde.KWin /KWin reconfigure
```

### Blur

```bash
kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig5 --file kwinrc --group Effect-blur --key BlurStrength 15
qdbus org.kde.KWin /KWin reconfigure
```

### Wobbly Windows

```bash
kwriteconfig5 --file kwinrc --group Plugins --key wobblywindowsEnabled true
qdbus org.kde.KWin /KWin reconfigure
```

## Обои

### Установка обоев

```bash
# Скачайте обои в формате JPG/PNG
mkdir -p ~/.local/share/wallpapers/MyWallpaper/contents/images
cp your-wallpaper.jpg ~/.local/share/wallpapers/MyWallpaper/contents/images/3840x2160.jpg

# Установите через настройки
# Правый клик на рабочем столе → Configure Desktop and Wallpaper
```

### Динамические обои

```bash
yay -S plasma5-wallpapers-dynamic
```

## Иконки

### Установка пакетов иконок

```bash
# Papirus (рекомендуется)
sudo pacman -S papirus-icon-theme

# Tela
yay -S tela-icon-theme

# Применение
systemsettings5
# Appearance → Icons → выберите тему
```

## Курсоры

```bash
# macOS курсоры
yay -S apple-cursor

# Применение
systemsettings5
# Appearance → Cursors → выберите тему
```

## Шрифты

### Установка шрифтов Apple

```bash
yay -S apple-fonts

# Или вручную
mkdir -p ~/.local/share/fonts
cp *.ttf ~/.local/share/fonts/
fc-cache -fv
```

### Настройка шрифтов системы

```bash
systemsettings5
# Appearance → Fonts
```

Рекомендуемые шрифты:
- General: SF Pro Display 10pt
- Fixed width: SF Mono 10pt
- Small: SF Pro Display 8pt
- Toolbar: SF Pro Display 10pt
- Menu: SF Pro Display 10pt
- Window title: SF Pro Display Bold 10pt

## Звуки

### Установка звуковой темы macOS

```bash
mkdir -p ~/.local/share/sounds
# Скопируйте звуки macOS в эту директорию

# Настройка
systemsettings5
# Notifications → Configure Events
```

## Панель задач (Top Bar)

### Настройка виджетов

1. Правый клик на панели → Add Widgets
2. Добавьте:
   - Application Menu (Global Menu)
   - System Tray
   - Digital Clock
   - Show Desktop

### Прозрачность панели

```bash
kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --key panelTransparency 90
```

## Dolphin (Finder)

### Превью файлов

```bash
sudo pacman -S ffmpegthumbs kdegraphics-thumbnailers kimageformats qt5-imageformats
```

### Боковая панель

1. Откройте Dolphin
2. View → Panels → Places
3. Настройте избранные папки

## Konsole (Terminal)

### Создание своей цветовой схемы

Файл: `~/.local/share/konsole/MyScheme.colorscheme`

Скопируйте и измените `macOS-Liquid.colorscheme`.

### Прозрачность

В профиле Konsole:
- Appearance → Edit → Background transparency: 10-20%

## GRUB тема

### Изменение фона

Замените файл `grub/background.png` на свой и пересоберите:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Сохранение настроек

### Экспорт конфигурации

```bash
# Создайте backup
tar -czf my-macos-liquid-config.tar.gz \
  ~/.config/kwinrc \
  ~/.config/lattedockrc \
  ~/.config/kdeglobals \
  ~/.config/konsolerc \
  ~/.config/dolphinrc
```

### Импорт конфигурации

```bash
tar -xzf my-macos-liquid-config.tar.gz -C ~/
qdbus org.kde.KWin /KWin reconfigure
```

## Дополнительные ресурсы

- KDE Store: https://store.kde.org
- Pling: https://www.pling.com
- GitHub: https://github.com/topics/kde-theme
