# ❓ Часто задаваемые вопросы (FAQ)

## Общие вопросы

### Что такое macOS Liquid Arch?

Это кастомный дистрибутив Arch Linux с дизайном macOS 26 и эффектами жидкого стекла. Основан на KDE Plasma с множеством настроек для имитации внешнего вида и поведения macOS.

### Это настоящая macOS?

Нет, это Linux дистрибутив, который выглядит и ведет себя как macOS, но работает на ядре Linux.

### Можно ли запускать macOS приложения?

Нативно - нет. Но вы можете использовать Wine для Windows приложений или виртуальные машины для macOS.

### Это бесплатно?

Да, полностью бесплатно и open source под лицензией GPL-3.0.

## Установка

### Какие системные требования?

- **Минимум**: 2 ГБ RAM, 20 ГБ диск, 64-bit процессор
- **Рекомендуется**: 4 ГБ RAM, 40 ГБ SSD
- **Оптимально**: 8 ГБ+ RAM, 100 ГБ+ NVMe SSD

### Какие учетные данные в Live ISO?

- **Пользователь**: `liveuser` (без пароля, автологин)
- **Root**: `root` (без пароля)
- **Sudo**: работает без пароля для группы wheel

### Как установить систему?

1. Загрузитесь с Live ISO (автологин под `liveuser`)
2. Дождитесь загрузки KDE Plasma (~30 секунд)
3. Появится диалог: "Установить macOS Liquid Arch на компьютер?"
4. Нажмите "Yes" - начнется установка компонентов из AUR:
   - Latte Dock (панель внизу)
   - Calamares (установщик)
   - Темы macOS (WhiteSur, MacSonoma, Albert)
5. Подождите ~10-15 минут (зависит от скорости интернета)
6. Calamares запустится автоматически
7. Следуйте инструкциям установщика

**Альтернативно:** Кликните иконку "Install macOS Liquid Arch" на рабочем столе

**Требования:** Интернет соединение для установки AUR пакетов

**Примечание:** Компоненты устанавливаются из AUR после загрузки Live ISO, чтобы избежать проблем с местом на диске при сборке.

### Можно ли установить рядом с Windows?

Да, поддерживается dual boot. Установщик Calamares позволяет выбрать раздел для установки.

### Поддерживается ли UEFI?

Да, поддерживаются как UEFI, так и Legacy BIOS.

### Как создать загрузочную флешку?

```bash
# Linux/macOS
sudo dd bs=4M if=macos-liquid-arch.iso of=/dev/sdX status=progress

# Windows
# Используйте Rufus или Etcher
```

## Использование

### Как открыть терминал?

- `Meta + T` или
- Найдите "Konsole" в меню приложений

### Как установить программы?

```bash
# Из официальных репозиториев
sudo pacman -S имя_пакета

# Из AUR (через yay)
yay -S имя_пакета
```

### Где настройки системы?

- Меню приложений → System Settings
- Или `Meta + Space` → введите "settings"

### Как изменить обои?

Правый клик на рабочем столе → Configure Desktop and Wallpaper

### Latte Dock не запускается

```bash
# Запустите вручную
latte-dock &

# Или добавьте в автозагрузку
cp /usr/share/applications/latte-dock.desktop ~/.config/autostart/
```

## Проблемы

### Нет звука

```bash
# Перезапустите PipeWire
systemctl --user restart pipewire pipewire-pulse

# Проверьте громкость
alsamixer
```

### Не работает Wi-Fi

```bash
# Перезапустите NetworkManager
sudo systemctl restart NetworkManager

# Проверьте статус
nmcli device status
```

### Черный экран после загрузки

Возможно проблема с драйверами видеокарты:

```bash
# Для NVIDIA
sudo pacman -S nvidia nvidia-utils

# Для AMD
sudo pacman -S xf86-video-amdgpu

# Для Intel
sudo pacman -S xf86-video-intel
```

### Тормозит интерфейс

```bash
# Отключите некоторые эффекты
kwriteconfig5 --file kwinrc --group Plugins --key wobblywindowsEnabled false
qdbus org.kde.KWin /KWin reconfigure
```

### Не работают горячие клавиши

Проверьте настройки:
- System Settings → Shortcuts → Global Shortcuts

## Кастомизация

### Как изменить тему?

```bash
# Установите Kvantum Manager
sudo pacman -S kvantum

# Запустите
kvantummanager
```

### Как добавить приложения в Dock?

Перетащите иконку из меню приложений на Latte Dock.

### Как изменить размер Dock?

Правый клик на Dock → Edit Dock → Appearance → Size

### Можно ли использовать GNOME вместо KDE?

Технически да, но потребуется переконфигурация. Дистрибутив оптимизирован для KDE.

## Обновления

### Как обновить систему?

```bash
# Полное обновление
sudo pacman -Syu

# С очисткой кэша
sudo pacman -Syu && sudo pacman -Sc
```

### Как часто выходят обновления?

Arch Linux - rolling release, обновления выходят постоянно. Рекомендуется обновляться раз в неделю.

### Нужно ли переустанавливать систему?

Нет, благодаря rolling release модели система всегда актуальна.

## Производительность

### Сколько RAM использует система?

- При загрузке: ~800 МБ
- С открытыми приложениями: 1.5-2 ГБ
- Под нагрузкой: 2-4 ГБ

### Быстрее ли это чем настоящая macOS?

На современном железе - сопоставимо. На старом железе - обычно быстрее.

### Можно ли использовать на слабом ПК?

Да, но рекомендуется отключить некоторые эффекты для лучшей производительности.

## Безопасность

### Безопасен ли дистрибутив?

Да, основан на Arch Linux с теми же стандартами безопасности.

### Нужен ли антивирус?

Для Linux антивирусы обычно не нужны, но можно установить ClamAV для проверки файлов.

### Как настроить firewall?

```bash
# Установите UFW
sudo pacman -S ufw

# Включите
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
```

## Разработка

### Можно ли использовать для программирования?

Да, отлично подходит. Установите нужные инструменты:

```bash
# VS Code
yay -S visual-studio-code-bin

# JetBrains Toolbox
yay -S jetbrains-toolbox

# Docker
sudo pacman -S docker docker-compose
```

### Поддерживается ли Node.js/Python/etc?

Да, все популярные языки и инструменты доступны через pacman или AUR.

## Сборка ISO

### Как собрать ISO самостоятельно?

**Способ 1: GitHub Actions (легко)**
- Fork репозитория
- Push изменений
- ISO соберется автоматически

**Способ 2: В виртуальной машине (рекомендуется)**
- См. [BUILD.md](../BUILD.md) - полная инструкция
- См. [ARCH-VM-QUICKSTART.md](ARCH-VM-QUICKSTART.md) - быстрый старт

**Способ 3: На существующем Arch Linux**
```bash
sudo pacman -S archiso git
git clone https://github.com/320kgpenguin/macos-liquid-arch.git
cd macos-liquid-arch/build
sudo bash build.sh
```

### Сколько времени занимает сборка?

- **GitHub Actions**: ~40 минут
- **Виртуальная машина**: ~30 минут
- **Реальный Arch**: ~20 минут

### Какие требования для сборки?

- **Arch Linux** (или виртуалка с Arch)
- **Интернет** для скачивания пакетов
- **Место на диске**: ~20 ГБ свободно
- **RAM**: минимум 2 ГБ (рекомендуется 4 ГБ+)

### Можно ли собрать на Ubuntu/Debian?

Нет, требуется именно Arch Linux. Используйте виртуальную машину.

### Где найти собранный ISO?

- **GitHub Actions**: Artifacts или Releases
- **Локально**: в папке `out/`

## Сообщество

### Где получить помощь?

- GitHub Issues
- Arch Linux Wiki
- Форумы Arch Linux
- Discord сервер (если есть)

### Как внести вклад?

См. [CONTRIBUTING.md](../CONTRIBUTING.md)

### Где сообщить об ошибке?

GitHub Issues: https://github.com/yourusername/macos-liquid-arch/issues

## Лицензия

### Под какой лицензией распространяется?

GPL-3.0 - свободное и открытое ПО.

### Можно ли использовать коммерчески?

Да, лицензия GPL-3.0 это позволяет.
