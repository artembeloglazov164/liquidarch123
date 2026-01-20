# Changelog

## [Unreleased]

### Changed
- Переименован дистрибутив: `320kgpenguin (macOS Liquid Arch)` → `macOS Arch`
- Заменены AUR темы на локальную тему MacVentura
- Упрощена установка тем - теперь все из одного источника
- Убраны упоминания GNOME (дистрибутив только на KDE Plasma)
- Удален устаревший параметр `version` из docker-compose.yml

### Added
- Тема MacVentura (полная тема macOS Ventura для KDE)
- Скрипт автоматической установки темы `/usr/local/bin/install-macventura-theme.sh`
- Kvantum theme engine для лучшей стилизации Qt приложений
- Документация по теме в `themes/README.md`

### Removed
- AUR пакеты тем: macsonoma-kde-git, whitesur-gtk-theme-git
- AUR пакеты: albert, lightly-qt
- Старый GNOME скрипт `setup-macos-style.sh`
- Система установки тем из ZIP файлов

### Fixed
- Исправлена ошибка установки yay (проверка существования файлов перед установкой)
- Упрощен процесс установки тем

## Структура тем

```
themes/
└── MacVentura/
    ├── aurorae/          # Темы окон
    ├── color-schemes/    # Цветовые схемы
    ├── Kvantum/          # Kvantum темы
    ├── plasma/           # Plasma темы
    ├── wallpapers/       # Обои
    ├── latte-dock/       # Конфигурации Latte Dock
    └── install.sh        # Скрипт установки
```

## Режимы сборки

### LITE (рекомендуется)
- Тема MacVentura устанавливается во время сборки ISO
- AUR пакеты (Latte Dock, Calamares, WhiteSur icons/cursors) устанавливаются при первом запуске
- Требует интернет при первом запуске
- Работает в GitHub Actions

### FULL (экспериментальный)
- Все устанавливается во время сборки ISO
- Не требует интернет при первом запуске
- Может не работать из-за ограничений памяти в GitHub Actions
- Рекомендуется только для локальной сборки в Docker

## Миграция

Если вы обновляетесь со старой версии:

1. Удалите старые AUR темы:
   ```bash
   yay -R macsonoma-kde-git whitesur-gtk-theme-git albert lightly-qt
   ```

2. Установите тему MacVentura:
   ```bash
   sudo bash /usr/local/bin/install-macventura-theme.sh
   ```

3. Примените тему через System Settings или Kvantum Manager
