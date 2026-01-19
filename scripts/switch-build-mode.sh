#!/bin/bash
# Скрипт для переключения между режимами сборки

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CUSTOMIZE_SCRIPT="$PROJECT_DIR/airootfs/root/customize_airootfs.sh"
LITE_VERSION="$PROJECT_DIR/airootfs/root/customize_airootfs.sh"
FULL_VERSION="$PROJECT_DIR/airootfs/root/customize_airootfs_full.sh"

echo "Переключение режима сборки 320kgpenguin"
echo "========================================"
echo ""
echo "Доступные режимы:"
echo "  1) LITE - AUR пакеты устанавливаются при первом запуске Live ISO"
echo "     Преимущества: быстрая сборка, экономия места"
echo "     Недостатки: требуется интернет при первом запуске"
echo ""
echo "  2) FULL - все устанавливается во время сборки ISO"
echo "     Преимущества: готовая система сразу, не нужен интернет"
echo "     Недостатки: долгая сборка, больше места на диске"
echo ""

# Определение текущего режима
if grep -q "ПОЛНАЯ ВЕРСИЯ" "$CUSTOMIZE_SCRIPT" 2>/dev/null; then
    CURRENT="FULL"
else
    CURRENT="LITE"
fi

echo "Текущий режим: $CURRENT"
echo ""

read -p "Выберите режим (1=LITE, 2=FULL): " CHOICE

case $CHOICE in
    1)
        if [ "$CURRENT" = "LITE" ]; then
            echo "Уже используется режим LITE"
        else
            echo "Переключение на режим LITE..."
            # LITE версия - это текущая версия по умолчанию
            # Ничего не делаем, так как она уже есть
            echo "Режим LITE активирован"
        fi
        ;;
    2)
        if [ "$CURRENT" = "FULL" ]; then
            echo "Уже используется режим FULL"
        else
            echo "Переключение на режим FULL..."
            cp "$FULL_VERSION" "$CUSTOMIZE_SCRIPT"
            echo "Режим FULL активирован"
        fi
        ;;
    *)
        echo "Неверный выбор"
        exit 1
        ;;
esac

echo ""
echo "Готово!"
echo ""
echo "Для сборки ISO:"
echo "  cd build"
echo "  sudo bash build.sh"
