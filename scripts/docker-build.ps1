# PowerShell скрипт для сборки ISO в Docker (Windows)

Write-Host "🐳 Сборка 320kgpenguin ISO в Docker" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Проверка Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker не установлен!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите Docker Desktop:"
    Write-Host "  https://docs.docker.com/desktop/install/windows-install/"
    exit 1
}

# Проверка Docker Compose
$composeV2 = docker compose version 2>$null
$composeV1 = Get-Command docker-compose -ErrorAction SilentlyContinue

if (-not $composeV2 -and -not $composeV1) {
    Write-Host "❌ Docker Compose не установлен!" -ForegroundColor Red
    exit 1
}

# Определение команды docker compose
if ($composeV2) {
    $DOCKER_COMPOSE = "docker", "compose"
} else {
    $DOCKER_COMPOSE = "docker-compose"
}

# Выбор режима сборки
Write-Host "Выберите режим сборки:"
Write-Host "  1) LITE - AUR пакеты устанавливаются при первом запуске (~20 мин)"
Write-Host "  2) FULL - все устанавливается во время сборки ISO (~40 мин)"
Write-Host ""
$MODE_CHOICE = Read-Host "Режим (1/2, по умолчанию 1)"

if ($MODE_CHOICE -eq "2") {
    $SERVICE = "archiso-builder-full"
    $MODE_NAME = "FULL"
} else {
    $SERVICE = "archiso-builder"
    $MODE_NAME = "LITE"
}

Write-Host ""
Write-Host "📦 Сборка Docker образа ($MODE_NAME режим)..." -ForegroundColor Yellow
& $DOCKER_COMPOSE build $SERVICE

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка сборки образа" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔨 Запуск сборки ISO..." -ForegroundColor Yellow
Write-Host "Режим: $MODE_NAME" -ForegroundColor Cyan
if ($MODE_NAME -eq "LITE") {
    Write-Host "Время: ~20-30 минут" -ForegroundColor Yellow
} else {
    Write-Host "Время: ~40-60 минут" -ForegroundColor Yellow
}
Write-Host ""

# Запуск контейнера
& $DOCKER_COMPOSE run --rm $SERVICE

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка сборки ISO" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Сборка завершена!" -ForegroundColor Green
Write-Host ""
Write-Host "📦 ISO файл:" -ForegroundColor Cyan
Get-ChildItem out/*.iso -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  $($_.Name) - $([math]::Round($_.Length / 1GB, 2)) GB" -ForegroundColor Green
}
Write-Host ""
Write-Host "📂 Расположение: $(Get-Location)\out\" -ForegroundColor Cyan
