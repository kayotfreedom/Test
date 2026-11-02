#!/bin/bash

# Проверка, что скрипт запущен от имени root (через sudo)
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами root: sudo bash install_docker.sh"
  exit 1
fi

# Имя пользователя, который вызвал sudo (чтобы добавить его в группу docker)
REAL_USER=${SUDO_USER:-$USER}

echo "=== 1. Обновление пакетов и установка зависимостей ==="
apt-get update
apt-get install -y ca-certificates curl gnupg

echo "=== 2. Удаление старых версий Docker (если есть) ==="
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
  apt-get remove -y $pkg 2>/dev/null || true
done

echo "=== 3. Добавление официального GPG-ключа Docker ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "=== 4. Добавление репозитория Docker ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

echo "=== 5. Установка Docker Engine и плагинов ==="
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== 6. Добавление пользователя $REAL_USER в группу docker ==="
usermod -aG docker $REAL_USER

echo "=== 7. Проверка установки ==="
docker --version
docker compose version

echo ""
echo "=================================================="
echo "УСТАНОВКА ЗАВЕРШЕНА!"
echo "Чтобы применить права без sudo, выйдите из системы и зайдите снова (или перезагрузите ВМ)."
echo "После этого проверьте работу командой: docker run hello-world"
echo "=================================================="
