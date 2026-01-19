# 🗑️ Управление артефактами GitHub Actions

## Где хранятся артефакты?

Артефакты GitHub Actions хранятся на серверах GitHub, а не локально. Они занимают место в вашем GitHub Storage.

**Лимиты:**
- **Free аккаунт**: 500 МБ storage, 2000 минут Actions/месяц
- **Pro аккаунт**: 2 ГБ storage, 3000 минут Actions/месяц
- **Team**: 50 ГБ storage, 10000 минут Actions/месяц

**Размер ISO:** ~3-4 ГБ → превышает лимит Free аккаунта!

---

## 📊 Проверка использования

### Через веб-интерфейс

1. GitHub → Settings → Billing and plans
2. Смотрите раздел **Storage for Actions and Packages**

### Через GitHub CLI

```bash
gh api /user/settings/billing/actions
```

---

## 🗑️ Удаление артефактов

### Способ 1: Веб-интерфейс (простой)

1. Откройте: https://github.com/320kgpenguin/macos-liquid-arch/actions
2. Выберите workflow run
3. Прокрутите вниз до **Artifacts**
4. Нажмите 🗑️ рядом с артефактом

**Удалить весь run:**
- Actions → выберите run → ⋯ (три точки) → **Delete workflow run**

### Способ 2: GitHub CLI (быстрый)

```bash
# Установка GitHub CLI
# Windows:
winget install GitHub.cli

# macOS:
brew install gh

# Linux:
# См. https://cli.github.com/

# Авторизация
gh auth login

# Список runs
gh run list --repo 320kgpenguin/macos-liquid-arch

# Удалить конкретный run
gh run delete RUN_ID --repo 320kgpenguin/macos-liquid-arch

# Удалить все неудачные runs
gh run list --repo 320kgpenguin/macos-liquid-arch --status failure --json databaseId -q '.[].databaseId' | xargs -I {} gh run delete {} --repo 320kgpenguin/macos-liquid-arch
```

### Способ 3: Автоматический скрипт (рекомендуется)

**Linux/macOS:**
```bash
bash scripts/cleanup-github-artifacts.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\cleanup-github-artifacts.ps1
```

**Меню:**
1. Все неудачные runs
2. Все завершенные runs (кроме последних 3)
3. Все runs старше 7 дней
4. Все runs (кроме последних 3)

### Способ 4: Автоматическая очистка (настроено)

В репозитории уже настроен workflow `.github/workflows/cleanup-artifacts.yml`:
- Запускается каждый день в 00:00 UTC
- Удаляет артефакты старше 7 дней
- Оставляет минимум 3 последних

**Запустить вручную:**
1. Actions → Cleanup Old Artifacts
2. Run workflow → Run workflow

---

## 💡 Рекомендации

### 1. Используйте Releases вместо Artifacts

Artifacts удаляются автоматически через 90 дней (или раньше, если настроено).
Releases хранятся постоянно и не занимают Actions Storage.

**Текущая настройка:**
- Artifacts: хранятся 7 дней (настроено в workflow)
- Releases: создаются автоматически при push в main

### 2. Скачивайте ISO сразу

После успешной сборки скачайте ISO из Artifacts или дождитесь создания Release.

### 3. Удаляйте неудачные runs

Неудачные runs тоже занимают место (логи, кэш).

```bash
# Быстрое удаление всех неудачных
gh run list --repo 320kgpenguin/macos-liquid-arch --status failure --json databaseId -q '.[].databaseId' | xargs -I {} gh run delete {} --repo 320kgpenguin/macos-liquid-arch
```

### 4. Настройте retention period

В `.github/workflows/build-iso.yml` уже настроено:

```yaml
- name: Upload ISO as Artifact
  uses: actions/upload-artifact@v4
  with:
    name: 320kgpenguin-iso
    path: out/*.iso
    retention-days: 7  # Хранить 7 дней
```

Можно уменьшить до 1-3 дней, если нужно экономить место.

---

## 🔍 Мониторинг

### Проверка размера артефактов

```bash
# Список всех артефактов
gh api repos/320kgpenguin/macos-liquid-arch/actions/artifacts

# С размерами (в байтах)
gh api repos/320kgpenguin/macos-liquid-arch/actions/artifacts --jq '.artifacts[] | {name: .name, size_mb: (.size_in_bytes / 1024 / 1024 | floor)}'
```

### Проверка использования Actions

```bash
# Минуты использования
gh api /repos/320kgpenguin/macos-liquid-arch/actions/billing/usage

# Storage
gh api /user/settings/billing/actions
```

---

## 🚨 Что делать при превышении лимита?

### Вариант 1: Удалить старые артефакты

```bash
bash scripts/cleanup-github-artifacts.sh
```

### Вариант 2: Уменьшить retention period

В `.github/workflows/build-iso.yml`:
```yaml
retention-days: 1  # Вместо 7
```

### Вариант 3: Отключить upload artifacts

Закомментируйте в `.github/workflows/build-iso.yml`:
```yaml
# - name: Upload ISO as Artifact
#   uses: actions/upload-artifact@v4
#   ...
```

ISO будет доступен только в Releases.

### Вариант 4: Upgrade аккаунт

GitHub Pro: $4/месяц → 2 ГБ storage

### Вариант 5: Собирать локально

См. [BUILD.md](../BUILD.md) - сборка в виртуальной машине.

---

## 📋 Чеклист очистки

- [ ] Удалить все неудачные runs
- [ ] Удалить runs старше 7 дней
- [ ] Оставить только последние 3 успешных
- [ ] Проверить использование storage
- [ ] Настроить автоматическую очистку

---

## 🔗 Полезные ссылки

- **Actions**: https://github.com/320kgpenguin/macos-liquid-arch/actions
- **Releases**: https://github.com/320kgpenguin/macos-liquid-arch/releases
- **Billing**: https://github.com/settings/billing
- **GitHub CLI**: https://cli.github.com/
- **Actions Docs**: https://docs.github.com/en/actions

---

## 🤖 Автоматизация

Добавьте в cron (Linux/macOS) или Task Scheduler (Windows):

```bash
# Каждый день в 2:00 удалять старые runs
0 2 * * * cd ~/macos-liquid-arch && bash scripts/cleanup-github-artifacts.sh
```

Или используйте встроенный workflow `cleanup-artifacts.yml` (уже настроен).

---

**Рекомендация:** Используйте Releases для постоянного хранения ISO, а Artifacts только для временного тестирования.
