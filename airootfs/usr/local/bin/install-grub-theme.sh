#!/bin/bash
# Установка GRUB темы macOS Arch

echo "🎨 Установка GRUB темы macOS Arch..."

THEME_SOURCE="/grub-theme"
THEME_DEST="/boot/grub/themes/macos-arch"

# Создание директории назначения
mkdir -p "$THEME_DEST"

# Проверка наличия темы
if [ -d "$THEME_SOURCE" ] && [ -f "$THEME_SOURCE/theme.txt" ]; then
    # Копирование темы из исходников
    echo "Копирование темы GRUB из $THEME_SOURCE..."
    cp -r "$THEME_SOURCE"/* "$THEME_DEST/"
    echo "✅ Тема Matrices-circle-window скопирована"
else
    echo "⚠️  Тема GRUB не найдена в $THEME_SOURCE"
    echo "Создание базовой темы..."
    
    cat > "$THEME_DEST/theme.txt" << 'EOF'
# macOS Arch GRUB Theme

title-text: ""
desktop-color: "#1e1e2e"
terminal-font: "Terminus Regular 14"

+ boot_menu {
  left = 15%
  top = 30%
  width = 70%
  height = 50%
  item_color = "#cdd6f4"
  selected_item_color = "#f5c2e7"
  item_height = 32
  item_padding = 10
  item_spacing = 8
}

+ label {
  top = 82%
  left = 0
  width = 100%
  height = 20
  text = "🍎 macOS Arch"
  color = "#cdd6f4"
  align = "center"
}

+ progress_bar {
  id = "__timeout__"
  left = 15%
  top = 80%
  height = 24
  width = 70%
  text_color = "#cdd6f4"
  fg_color = "#f5c2e7"
  bg_color = "#313244"
  border_color = "#45475a"
}
EOF
    echo "✅ Базовая тема создана"
fi

# Обновление GRUB конфигурации
if [ -f /etc/default/grub ]; then
    echo "Обновление /etc/default/grub..."
    
    # Удаляем старые строки GRUB_THEME
    sed -i '/^#GRUB_THEME=/d' /etc/default/grub
    sed -i '/^GRUB_THEME=/d' /etc/default/grub
    
    # Добавляем новую строку
    echo 'GRUB_THEME="/boot/grub/themes/macos-arch/theme.txt"' >> /etc/default/grub
    
    echo "✅ GRUB конфигурация обновлена"
else
    echo "⚠️  /etc/default/grub не найден (это нормально для Live ISO)"
fi

echo "✅ GRUB тема установлена!"
echo ""
echo "Тема будет активна после установки системы на диск"
echo "После установки выполните: sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo ""
