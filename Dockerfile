# Dockerfile для сборки 320kgpenguin ISO
FROM archlinux:latest

# Аргумент для выбора режима сборки (lite или full)
ARG BUILD_MODE=lite

# Обновление системы и установка зависимостей
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    archiso \
    git \
    base-devel \
    sudo \
    fakeroot \
    && pacman -Scc --noconfirm

# Создание пользователя builder
RUN useradd -m -G wheel -s /bin/bash builder && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Исправление для makepkg в Docker
RUN echo "PKGDEST=/tmp/packages" >> /etc/makepkg.conf && \
    mkdir -p /tmp/packages && \
    chown builder:builder /tmp/packages

# Рабочая директория
WORKDIR /build

# Копирование проекта
COPY --chown=builder:builder . /build/

# Переключение режима сборки
RUN if [ "$BUILD_MODE" = "full" ]; then \
        cp /build/airootfs/root/customize_airootfs_full.sh /build/airootfs/root/customize_airootfs.sh; \
        echo "Build mode: FULL (all packages installed during ISO build)"; \
    else \
        echo "Build mode: LITE (AUR packages installed on first boot)"; \
    fi

# Переключение на пользователя builder
USER builder

# Команда по умолчанию
CMD ["bash", "-c", "cd /build/build && sudo bash build.sh"]
