# PowerShell скрипт для удаления старых артефактов GitHub Actions
# Для Windows

$REPO = "320kgpenguin/macos-liquid-arch"

Write-Host "🗑️  Очистка артефактов GitHub Actions" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Репозиторий: $REPO"
Write-Host ""

# Проверка установки gh
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ GitHub CLI (gh) не установлен!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите:"
    Write-Host "  winget install GitHub.cli"
    Write-Host ""
    Write-Host "Или скачайте: https://cli.github.com/"
    exit 1
}

# Проверка авторизации
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "🔐 Требуется авторизация..." -ForegroundColor Yellow
    gh auth login
}

Write-Host "📊 Получение списка workflow runs..." -ForegroundColor Cyan
$runs = gh run list --repo $REPO --limit 100 --json databaseId,status,conclusion,createdAt,name | ConvertFrom-Json

$total = $runs.Count
Write-Host "Найдено runs: $total"
Write-Host ""

# Статистика
$completed = ($runs | Where-Object { $_.status -eq "completed" }).Count
$failed = ($runs | Where-Object { $_.conclusion -eq "failure" }).Count
$success = ($runs | Where-Object { $_.conclusion -eq "success" }).Count

Write-Host "Статистика:"
Write-Host "  ✅ Успешных: $success" -ForegroundColor Green
Write-Host "  ❌ Неудачных: $failed" -ForegroundColor Red
Write-Host "  📦 Завершенных: $completed" -ForegroundColor Yellow
Write-Host ""

# Меню
Write-Host "Что удалить?"
Write-Host "  1) Все неудачные runs"
Write-Host "  2) Все завершенные runs (кроме последних 3)"
Write-Host "  3) Все runs старше 7 дней"
Write-Host "  4) Все runs (кроме последних 3)"
Write-Host "  5) Отмена"
Write-Host ""
$choice = Read-Host "Выберите (1-5)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🗑️  Удаление неудачных runs..." -ForegroundColor Yellow
        $failedRuns = $runs | Where-Object { $_.conclusion -eq "failure" }
        foreach ($run in $failedRuns) {
            Write-Host "Удаление run #$($run.databaseId)..."
            gh run delete $run.databaseId --repo $REPO
        }
    }
    "2" {
        Write-Host ""
        Write-Host "🗑️  Удаление завершенных runs (кроме последних 3)..." -ForegroundColor Yellow
        $completedRuns = $runs | Where-Object { $_.status -eq "completed" } | Select-Object -Skip 3
        foreach ($run in $completedRuns) {
            Write-Host "Удаление run #$($run.databaseId)..."
            gh run delete $run.databaseId --repo $REPO
        }
    }
    "3" {
        Write-Host ""
        Write-Host "🗑️  Удаление runs старше 7 дней..." -ForegroundColor Yellow
        $weekAgo = (Get-Date).AddDays(-7)
        $oldRuns = $runs | Where-Object { [DateTime]$_.createdAt -lt $weekAgo }
        foreach ($run in $oldRuns) {
            Write-Host "Удаление run #$($run.databaseId)..."
            gh run delete $run.databaseId --repo $REPO
        }
    }
    "4" {
        Write-Host ""
        Write-Host "🗑️  Удаление всех runs (кроме последних 3)..." -ForegroundColor Yellow
        $oldRuns = $runs | Select-Object -Skip 3
        foreach ($run in $oldRuns) {
            Write-Host "Удаление run #$($run.databaseId)..."
            gh run delete $run.databaseId --repo $REPO
        }
    }
    "5" {
        Write-Host "Отменено" -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "❌ Неверный выбор" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Очистка завершена!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Проверьте результат:"
Write-Host "  https://github.com/$REPO/actions"
