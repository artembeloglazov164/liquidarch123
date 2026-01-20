# Темы для macOS Arch

## MacVentura Theme

Полная тема macOS Ventura для KDE Plasma, включающая:

- **Aurorae Theme** - оформление окон (с закругленными углами)
- **Kvantum Theme** - стилизация Qt приложений
- **Plasma Color Scheme** - цветовая схема
- **Plasma Desktop Theme** - тема рабочего стола
- **Plasma Global Theme** - глобальная тема
- **Wallpapers** - обои macOS Ventura
- **Latte Dock layouts** - готовые конфигурации Latte Dock

### Установка

Тема устанавливается автоматически при сборке ISO через скрипт:
```bash
/usr/local/bin/install-macventura-theme.sh
```

### Ручная установка

Если нужно переустановить тему:
```bash
cd /usr/share/macventura-theme
sudo bash install.sh --round --color dark
```

### Применение темы

Тема применяется автоматически для всех пользователей. Для ручного применения:

1. **Kvantum Manager**:
   ```bash
   kvantummanager
   ```
   Выберите тему "MacVentura"

2. **System Settings**:
   - Appearance → Global Theme → MacVentura-Dark
   - Appearance → Colors → MacVenturaDark
   - Window Decorations → MacVentura-Dark

### Рекомендуемые дополнения

Для полного macOS опыта установите:
- **WhiteSur Icon Theme** (устанавливается автоматически из AUR)
- **WhiteSur Cursors** (устанавливается автоматически из AUR)

### Источник

Тема MacVentura: https://github.com/vinceliuice/MacVentura-kde

### Лицензия

См. LICENSE файл в директории MacVentura/
