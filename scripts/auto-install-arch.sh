#!/bin/bash
# Автоматическая установка Arch Linux для сборки ISO
# ВНИМАНИЕ: Этот скрипт отформатирует /dev/sda!

set -e

echo "🐧 Автоматическая установка Arch Linux для сборки 320kgpenguin"
echo "================================================================"
echo ""
echo "⚠️  ВНИМАНИЕ: Этот скрипт:"
echo "  • Отформатирует /dev/sda"
echo "  • Установит минимальный Arch Linux"
echo "  • Создаст пользователя builder/builder"
echo ""
read -p "Продолжить? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Отменено"
    exit 0
fi

DISK="/dev/sda"

echo ""
echo "📦 Шаг 1/10: Разметка диска..."
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary fat32 1MiB 512MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary ext4 512MiB 100%

sleep 2

echo "💾 Шаг 2/10: Форматирование..."
mkfs.fat -F32 "${DISK}1"
mkfs.ext4 -F "${DISK}2"

echo "📂 Шаг 3/10: Монтирование..."
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

echo "📦 Шаг 4/10: Установка базовой системы..."
pacstrap /mnt base base-devel linux linux-firmware

echo "📝 Шаг 5/10: Генерация fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "⚙️  Шаг 6/10: Настройка системы..."
arch-chroot /mnt /bin/bash << 'EOFCHROOT'

# Время
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# Локаль
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "archbuild" > /etc/hostname
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   archbuild.localdomain archbuild
EOF

# Пароли
echo "root:root" | chpasswd

# Пользователь
useradd -m -G wheel -s /bin/bash builder
echo "builder:builder" | chpasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Пакеты
pacman -S --noconfirm grub efibootmgr networkmanager git vim nano sudo archiso

# GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# NetworkManager
systemctl enable NetworkManager

EOFCHROOT

echo "🎉 Шаг 7/10: Клонирование репозитория..."
arch-chroot /mnt /bin/bash << 'EOFGIT'
su - builder -c "cd ~ && git clone https://github.com/320kgpenguin/macos-liquid-arch.git"
EOFGIT

echo "📝 Шаг 8/10: Создание скрипта сборки..."
cat > /mnt/home/builder/build-iso.sh << 'EOFBUILD'
#!/bin/bash
cd ~/macos-liquid-arch/build
sudo bash build.sh
EOFBUILD

arch-chroot /mnt chown builder:builder /home/builder/build-iso.sh
arch-chroot /mnt chmod +x /home/builder/build-iso.sh

echo "📝 Шаг 9/10: Создание README..."
cat > /mnt/home/builder/README.txt << 'EOFREADME'
🐧 Arch Linux для сборки 320kgpenguin ISO

👤 Пользователи:
  builder / builder (sudo без пароля)
  root / root

🔨 Сборка ISO:
  cd ~/macos-liquid-arch/build
  sudo bash build.sh

  Или используйте:
  ~/build-iso.sh

📤 Копирование ISO на хост:
  cd ~/macos-liquid-arch/out
  python -m http.server 8000
  # Откройте на хосте: http://IP_VM:8000

🔄 Обновление кода:
  cd ~/macos-liquid-arch
  git pull

📚 Документация:
  ~/macos-liquid-arch/BUILD.md
  ~/macos-liquid-arch/docs/ARCH-VM-QUICKSTART.md

EOFREADME

arch-chroot /mnt chown builder:builder /home/builder/README.txt

echo "📤 Шаг 10/10: Размонтирование..."
umount -R /mnt

echo ""
echo "================================================================"
echo "✅ Установка завершена!"
echo ""
echo "🎯 Что дальше:"
echo "  1. Перезагрузите систему: reboot"
echo "  2. Войдите как: builder / builder"
echo "  3. Прочитайте: cat ~/README.txt"
echo "  4. Соберите ISO: ~/build-iso.sh"
echo ""
echo "⏱️  Время сборки ISO: ~30 минут"
echo "📦 Результат: ~/macos-liquid-arch/out/*.iso"
echo ""
echo "================================================================"
