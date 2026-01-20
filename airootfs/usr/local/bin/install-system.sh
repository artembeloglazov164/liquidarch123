#!/bin/bash
# Простой установщик macOS Liquid Arch

echo "🍎 Установщик macOS Liquid Arch"
echo ""
echo "⚠️  ВНИМАНИЕ: Этот скрипт отформатирует выбранный диск!"
echo ""

# Показать диски
echo "Доступные диски:"
lsblk -d -o NAME,SIZE,TYPE | grep disk
echo ""

read -p "Введите имя диска для установки (например: sda, nvme0n1): " DISK
DISK="/dev/$DISK"

if [ ! -b "$DISK" ]; then
    echo "❌ Диск $DISK не найден!"
    exit 1
fi

echo ""
echo "Будет использован диск: $DISK"
lsblk "$DISK"
echo ""
read -p "Продолжить? Все данные будут удалены! (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Установка отменена"
    exit 0
fi

echo ""
echo "🔨 Начинаем установку..."

# Разметка диска
echo "📦 Разметка диска..."
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary fat32 1MiB 512MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary ext4 512MiB 100%

# Определение имен разделов
if [[ "$DISK" == *"nvme"* ]]; then
    BOOT="${DISK}p1"
    ROOT="${DISK}p2"
else
    BOOT="${DISK}1"
    ROOT="${DISK}2"
fi

sleep 2

# Форматирование
echo "💾 Форматирование разделов..."
mkfs.fat -F32 "$BOOT"
mkfs.ext4 -F "$ROOT"

# Монтирование
echo "📂 Монтирование..."
mount "$ROOT" /mnt
mkdir -p /mnt/boot
mount "$BOOT" /mnt/boot

# Установка базовой системы
echo "📦 Установка базовой системы (это займет время)..."
pacstrap /mnt base base-devel linux linux-firmware linux-headers \
    grub efibootmgr networkmanager \
    gnome gdm gnome-tweaks \
    gnome-shell-extensions gnome-shell-extension-appindicator \
    papirus-icon-theme \
    firefox nautilus gnome-terminal \
    git wget curl vim nano htop \
    pulseaudio pulseaudio-alsa pavucontrol \
    ttf-dejavu ttf-roboto noto-fonts

# Генерация fstab
echo "📝 Генерация fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Настройка системы
echo "⚙️  Настройка системы..."
arch-chroot /mnt /bin/bash << 'EOFCHROOT'

# Часовой пояс
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# Локаль
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf

# Hostname
echo "macos-liquid-arch" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   macos-liquid-arch.localdomain macos-liquid-arch
EOF

# Пользователь
echo "Создание пользователя..."
useradd -m -G wheel,audio,video,storage,optical -s /bin/bash user
echo "user:user" | chpasswd
echo "root:root" | chpasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Включение служб
systemctl enable NetworkManager
systemctl enable gdm

# GRUB
echo "Установка GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=macOS-Liquid-Arch
grub-mkconfig -o /boot/grub/grub.cfg

EOFCHROOT

arch-chroot /mnt chown -R user:user /home/user

# Размонтирование
echo "📤 Размонтирование..."
umount -R /mnt

echo ""
echo "✅ Установка завершена!"
echo ""
echo "🍎 macOS Liquid Arch установлен!"
echo ""
echo "Пользователи:"
echo "  user / user"
echo "  root / root"
echo ""
echo "Перезагрузите систему: reboot"
