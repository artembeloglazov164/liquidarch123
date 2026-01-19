# 🐳 Сборка ISO в Docker

## Преимущества Docker

- ✅ Работает на Windows, macOS, Linux
- ✅ Не нужна виртуальная машина
- ✅ Изолированная среда сборки
- ✅ Кэширование пакетов между сборками
- ✅ Легко очистить после сборки

---

## 📋 Требования

### Windows

1. **Docker Desktop**: https://docs.docker.com/desktop/install/windows-install/
2. **WSL 2** (рекомендуется)
3. **Минимум 20 ГБ свободного места**
4. **4 ГБ RAM** (рекомендуется 8 ГБ)

### macOS

1. **Docker Desktop**: https://docs.docker.com/desktop/install/mac-install/
2. **Минимум 20 ГБ свободного места**
3. **4 ГБ RAM** (рекомендуется 8 ГБ)

### Linux

1. **Docker Engine**: https://docs.docker.com/engine/install/
2. **Docker Compose**: обычно включен в Docker Engine
3. **Минимум 20 ГБ свободного места**
4. **4 ГБ RAM** (рекомендуется 8 ГБ)

---

## 🚀 Быстрый старт

### Windows (PowerShell)

```powershell
# Клонирование репозитория
git clone https://github.com/320kgpenguin/macos-liquid-arch.git
cd macos-liquid-arch

# Запуск сборки
.\scripts\docker-build.ps1

# Ждите ~20-40 минут
# ISO будет в папке out/
```

### Linux/macOS

```bash
# Клонирование репозитория
git clone https://github.com/320kgpenguin/macos-liquid-arch.git
cd macos-liquid-arch

# Запуск сборки
bash scripts/docker-build.sh

# Ждите ~20-40 минут
# ISO будет в папке out/
```

---

## 📝 Ручная сборка

### 1. Сборка Docker образа

```bash
# Сборка образа
docker compose build

# Или с docker-compose
docker-compose build
```

### 2. Запуск сборки ISO

```bash
# Запуск контейнера
docker compose run --rm archiso-builder

# Или с docker-compose
docker-compose run --rm archiso-builder
```

### 3. Результат

ISO файл будет создан в папке `out/`:

```bash
ls -lh out/
# 320kgpenguin-2026.01.19-x86_64.iso (~3-4 ГБ)
```

---

## 🔧 Дополнительные команды

### Интерактивный режим

Запустить контейнер в интерактивном режиме:

```bash
# Запуск bash в контейнере
docker compose run --rm archiso-builder bash

# Внутри контейнера:
cd /build/build
sudo bash build.sh
```

### Очистка перед новой сборкой

```bash
# Удалить старые файлы сборки
rm -rf build/work build/out out/*

# Или в контейнере
docker compose run --rm archiso-builder bash -c "cd /build/build && sudo rm -rf work out"
```

### Просмотр логов

```bash
# Логи последней сборки
docker compose logs
```

### Остановка контейнера

```bash
# Остановить все контейнеры
docker compose down

# Удалить контейнеры и volumes
docker compose down -v
```

---

## 💾 Кэширование

Docker автоматически кэширует:
- **Слои образа** - ускоряет пересборку образа
- **Пакеты pacman** - в volume `pacman-cache`
- **Исходники** - монтируются из текущей директории

### Очистка кэша

```bash
# Очистить кэш pacman
docker compose run --rm archiso-builder sudo pacman -Scc

# Удалить volume с кэшем
docker compose down -v
docker volume rm 320kgpenguin-builder_pacman-cache
```

---

## 🔍 Отладка

### Проверка Docker

```bash
# Версия Docker
docker --version

# Версия Docker Compose
docker compose version
# или
docker-compose --version

# Информация о системе
docker info
```

### Проблемы с правами (Linux)

```bash
# Добавить пользователя в группу docker
sudo usermod -aG docker $USER

# Перелогиниться или выполнить
newgrp docker
```

### Проблемы с местом на диске

```bash
# Проверить использование места
docker system df

# Очистить неиспользуемые данные
docker system prune -a

# Очистить все (включая volumes)
docker system prune -a --volumes
```

### Ошибки сборки

```bash
# Пересобрать образ без кэша
docker compose build --no-cache

# Запустить с выводом всех логов
docker compose run --rm archiso-builder bash -c "cd /build/build && sudo bash -x build.sh"
```

---

## 📊 Сравнение методов сборки

| Метод | Время | Сложность | Требования | Кэш |
|-------|-------|-----------|------------|-----|
| GitHub Actions | ~40 мин | Легко | GitHub аккаунт | ❌ |
| Docker | ~30 мин | Средне | Docker | ✅ |
| Виртуальная машина | ~30 мин | Средне | VirtualBox/VMware | ✅ |
| Реальный Arch | ~20 мин | Сложно | Arch Linux | ✅ |

---

## 🎯 Рекомендации

### Для разработки

Используйте Docker - быстро, удобно, с кэшированием.

```bash
# Первая сборка
bash scripts/docker-build.sh  # ~30 минут

# Изменили конфигурацию
# Повторная сборка
bash scripts/docker-build.sh  # ~20 минут (с кэшем)
```

### Для CI/CD

Используйте GitHub Actions - автоматическая сборка при push.

### Для продакшена

Используйте реальный Arch Linux - максимальная скорость и контроль.

---

## 🐛 Частые проблемы

### "Cannot connect to Docker daemon"

**Решение:**
```bash
# Запустите Docker Desktop (Windows/macOS)
# Или запустите Docker daemon (Linux)
sudo systemctl start docker
```

### "Permission denied" (Linux)

**Решение:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### "No space left on device"

**Решение:**
```bash
# Очистите Docker
docker system prune -a --volumes

# Увеличьте место для Docker Desktop (Windows/macOS)
# Settings → Resources → Disk image size
```

### "Build failed" в контейнере

**Решение:**
```bash
# Пересоберите образ без кэша
docker compose build --no-cache

# Проверьте логи
docker compose logs
```

---

## 📚 Дополнительная информация

### Структура проекта

```
.
├── Dockerfile              # Определение Docker образа
├── docker-compose.yml      # Конфигурация Docker Compose
├── scripts/
│   ├── docker-build.sh     # Скрипт сборки (Linux/macOS)
│   └── docker-build.ps1    # Скрипт сборки (Windows)
├── build/
│   └── build.sh            # Скрипт сборки ISO
└── out/                    # Выходная директория для ISO
```

### Dockerfile

Образ основан на `archlinux:latest` и включает:
- archiso
- git
- base-devel
- sudo

### docker-compose.yml

Конфигурация включает:
- Privileged mode (для archiso)
- Volume для кэша pacman
- Монтирование текущей директории
- Монтирование out/ для ISO

---

## 🔗 Полезные ссылки

- **Docker Desktop**: https://www.docker.com/products/docker-desktop/
- **Docker Docs**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/
- **Arch Linux Docker**: https://hub.docker.com/_/archlinux
- **archiso**: https://wiki.archlinux.org/title/Archiso

---

## 💡 Советы

1. **Используйте SSD** - значительно ускоряет сборку
2. **Выделите больше RAM** - Docker Desktop → Settings → Resources
3. **Включите WSL 2** (Windows) - быстрее чем Hyper-V
4. **Не удаляйте volume** - сохраняет кэш пакетов
5. **Делайте snapshot** - после успешной сборки

---

**Готово! Теперь вы можете собирать ISO в Docker! 🐳**
