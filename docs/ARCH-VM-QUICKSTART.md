# ⚡ Быстрая установка Arch Linux в VM для сборки ISO

## 🎯 Цель
Установить минимальный Arch Linux в виртуалку для сборки 320kgpenguin ISO.

---

## 📋 Подготовка

1. **Скачайте Arch ISO**: https://archlinux.org/download/
2. **Создайте VM**:
   - RAM: 4 ГБ+
   - Диск: 30 ГБ
   - CPU: 2+
   - Network: NAT/Bridged

---

## 🚀 Установка (копипаста)

### Загрузитесь с Arch ISO, затем:

```bash
# === 1. РАЗМЕТКА ДИСКА ===
cfdisk /dev/sda
# Создайте:
# sda1: 512M, Type: EFI System
# sda2: остальное, Type: Linux filesystem
# Write → yes → Quit

# === 2. ФОРМАТИРОВАНИЕ ===
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# === 3. МОНТИРОВАНИЕ ===
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# === 4. УСТАНОВКА БАЗЫ ===
pacstrap /mnt base base-devel linux linux-firmware

# === 5. FSTAB ===
genfstab -U /mnt >> /mnt/etc/fstab

# === 6. CHROOT ===
arch-chroot /mnt

# === 7. НАСТРОЙКА ===
# Время
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# Локаль
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "archbuild" > /etc/hostname
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   archbuild
EOF

# Пароли
echo "root:root" | chpasswd

# Пользователь
useradd -m -G wheel -s /bin/bash builder
echo "builder:builder" | chpasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# === 8. ПАКЕТЫ ===
pacman -S --noconfirm grub efibootmgr networkmanager git vim sudo

# === 9. GRUB ===
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# === 10. СЕТЬ ===
systemctl enable NetworkManager

# === 11. ВЫХОД ===
exit
umount -R /mnt
reboot
```

---

## 🔨 Сборка ISO

### После перезагрузки (логин: builder / builder):

```bash
# Установка archiso
sudo pacman -S --noconfirm archiso git

# Клонирование репозитория
git clone https://github.com/320kgpenguin/macos-liquid-arch.git
cd macos-liquid-arch/build

# СБОРКА!
sudo bash build.sh

# Ждите ~30 минут
# ISO будет в ../out/
```

---

## 📤 Копирование ISO на хост

### Вариант 1: Python HTTP сервер

```bash
cd ~/macos-liquid-arch/out
python -m http.server 8000

# На хосте откройте: http://IP_ВИРТУАЛКИ:8000
# Узнать IP: ip addr show
```

### Вариант 2: SCP

```bash
# В VM:
sudo pacman -S openssh
sudo systemctl start sshd
ip addr show  # Узнайте IP

# На хосте (PowerShell):
scp builder@IP_VM:~/macos-liquid-arch/out/*.iso C:\Downloads\
```

### Вариант 3: Общая папка (VirtualBox)

```bash
# Настройте в VirtualBox: Devices → Shared Folders
# В VM:
sudo pacman -S virtualbox-guest-utils
sudo mkdir /mnt/shared
sudo mount -t vboxsf FOLDER_NAME /mnt/shared
sudo cp ~/macos-liquid-arch/out/*.iso /mnt/shared/
```

---

## 💾 Снимок VM

После установки сделайте snapshot:
- VirtualBox: Machine → Take Snapshot
- Имя: "Clean Arch + archiso"

Теперь можно быстро откатиться для новой сборки!

---

## 🔄 Повторная сборка

```bash
cd ~/macos-liquid-arch
git pull  # Обновить код
cd build
sudo rm -rf work/ out/  # Очистить
sudo bash build.sh  # Собрать заново
```

---

## ⏱️ Время

- **Установка Arch**: ~10 минут
- **Первая сборка ISO**: ~30 минут
- **Повторная сборка**: ~20 минут

---

## 🎯 Автоматизация

Создайте скрипт `~/rebuild.sh`:

```bash
#!/bin/bash
cd ~/macos-liquid-arch
git pull
cd build
sudo rm -rf work/ out/
sudo bash build.sh
cd ../out
python -m http.server 8000
```

Использование:
```bash
chmod +x ~/rebuild.sh
~/rebuild.sh
```

---

## 📊 Системные требования VM

| Компонент | Минимум | Рекомендуется |
|-----------|---------|---------------|
| RAM | 2 ГБ | 4-8 ГБ |
| CPU | 1 ядро | 2-4 ядра |
| Диск | 20 ГБ | 30-50 ГБ |
| Сеть | NAT | Bridged |

---

## 🐛 Частые проблемы

### Нет интернета после установки
```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

### Ошибка при установке пакетов
```bash
sudo pacman -Syy
sudo pacman -S archlinux-keyring
```

### Не хватает места
```bash
sudo pacman -Scc  # Очистить кэш
df -h  # Проверить место
```

---

**Готово! Теперь у вас есть сборочная машина! 🚀**

Полная документация: [BUILD.md](../BUILD.md)
