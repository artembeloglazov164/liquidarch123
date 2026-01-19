#!/bin/bash
# Установка GRUB темы 320kgpenguin

echo "🎨 Установка GRUB темы 320kgpenguin..."

THEME_DIR="/boot/grub/themes/320kgpenguin"

# Создание директории темы
mkdir -p "$THEME_DIR"

# Копирование theme.txt
cat > "$THEME_DIR/theme.txt" << 'EOF'
# 320kgpenguin macOS Liquid Glass GRUB Theme

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
  text = "🐧 320kgpenguin - macOS Liquid Arch"
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

# Создание простого фона
convert -size 1920x1080 xc:"#1e1e2e" "$THEME_DIR/background.png" 2>/dev/null || \
    echo "⚠️  ImageMagick не установлен, фон не создан"

# Обновление GRUB конфигурации
if [ -f /etc/default/grub ]; then
    sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/320kgpenguin/theme.txt"|' /etc/default/grub
    sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/320kgpenguin/theme.txt"|' /etc/default/grub
    
    # Если строки нет, добавляем
    if ! grep -q "GRUB_THEME=" /etc/default/grub; then
        echo 'GRUB_THEME="/boot/grub/themes/320kgpenguin/theme.txt"' >> /etc/default/grub
    fi
fi

echo "✅ GRUB тема установлена!"
echo "Запустите: grub-mkconfig -o /boot/grub/grub.cfg"
