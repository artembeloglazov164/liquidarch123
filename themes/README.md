# Темы macOS для macOS Arch

Положите сюда ZIP файлы с темами:

## Структура:

```
themes/
├── MacSonoma-kde.zip          # Plasma тема
├── Whitesur-gtk-theme.zip     # GTK тема
├── Whitesur-icon-theme.zip    # Иконки
├── Whitesur-cursors.zip       # Курсоры
├── Lightly.zip                # Application Style
└── Albert.zip                 # Launcher (опционально)
```

## Формат ZIP:

Каждый ZIP должен содержать готовую структуру для установки:

### Plasma Theme (MacSonoma-kde.zip)
```
MacSonoma/
├── metadata.desktop
├── colors
└── ...
```
Устанавливается в: `~/.local/share/plasma/desktoptheme/`

### GTK Theme (Whitesur-gtk-theme.zip)
```
WhiteSur/
├── gtk-3.0/
├── gtk-4.0/
└── ...
```
Устанавливается в: `~/.themes/`

### Icon Theme (Whitesur-icon-theme.zip)
```
WhiteSur/
├── index.theme
├── apps/
├── places/
└── ...
```
Устанавливается в: `~/.local/share/icons/`

### Cursors (Whitesur-cursors.zip)
```
WhiteSur-cursors/
├── index.theme
└── cursors/
```
Устанавливается в: `~/.local/share/icons/`

### Lightly (Lightly.zip)
```
Lightly/
└── (файлы стиля)
```
Устанавливается в: `~/.local/share/kstyle/`

## Автоматическая установка

Скрипт `install-themes.sh` автоматически:
1. Найдет все ZIP файлы в этой директории
2. Распакует их в правильные места
3. Применит темы
4. Настроит Albert launcher (если есть)

Просто положите ZIP файлы сюда и пересоберите ISO!
