# PowerShell скрипт для переключения между режимами сборки

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
$CUSTOMIZE_SCRIPT = Join-Path $PROJECT_DIR "airootfs\root\customize_airootfs.sh"
$FULL_VERSION = Join-Path $PROJECT_DIR "airootfs\root\customize_airootfs_full.sh"

Write-Host "Переключение режима сборки 320kgpenguin" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Доступные режимы:"
Write-Host "  1) LITE - AUR пакеты устанавливаются при первом запуске Live ISO"
Write-Host "     Преимущества: быстрая сборка, экономия места"
Write-Host "     Недостатки: требуется интернет при первом запуске"
Write-Host ""
Write-Host "  2) FULL - все устанавливается во время сборки ISO"
Write-Host "     Преимущества: готовая система сразу, не нужен интернет"
Write-Host "     Недостатки: долгая сборка, больше места на диске"
Write-Host ""

# Определение текущего режима
$content = Get-Content $CUSTOMIZE_SCRIPT -Raw -ErrorAction SilentlyContinue
if ($content -match "ПОЛНАЯ ВЕРСИЯ") {
    $CURRENT = "FULL"
} else {
    $CURRENT = "LITE"
}

Write-Host "Текущий режим: $CURRENT" -ForegroundColor Yellow
Write-Host ""

$CHOICE = Read-Host "Выберите режим (1=LITE, 2=FULL)"

switch ($CHOICE) {
    "1" {
        if ($CURRENT -eq "LITE") {
            Write-Host "Уже используется режим LITE" -ForegroundColor Yellow
        } else {
            Write-Host "Переключение на режим LITE..." -ForegroundColor Yellow
            # Восстановление LITE версии из git
            git checkout -- airootfs/root/customize_airootfs.sh
            Write-Host "Режим LITE активирован" -ForegroundColor Green
        }
    }
    "2" {
        if ($CURRENT -eq "FULL") {
            Write-Host "Уже используется режим FULL" -ForegroundColor Yellow
        } else {
            Write-Host "Переключение на режим FULL..." -ForegroundColor Yellow
            Copy-Item $FULL_VERSION $CUSTOMIZE_SCRIPT -Force
            Write-Host "Режим FULL активирован" -ForegroundColor Green
        }
    }
    default {
        Write-Host "Неверный выбор" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Готово!" -ForegroundColor Green
Write-Host ""
Write-Host "Для сборки ISO:"
Write-Host "  cd build"
Write-Host "  sudo bash build.sh"
