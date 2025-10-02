#!/bin/bash

# 🚀 DevOps Dashboard — автоматический деплой
set -e

echo "🔥 Начинаем развертывание DevOps Dashboard..."

# Проверяем Docker и Docker Compose v2
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен!"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose v2 не найден! Используйте встроенный плагин docker compose."
    exit 1
fi

# Останавливаем старые контейнеры (по умолчанию из docker-compose.yml)
echo "⏹️ Останавливаем старые контейнеры..."
docker compose down --remove-orphans

# Запускаем новые контейнеры
echo "🚀 Запускаем контейнеры..."
docker compose up -d

# Ждём, пока сервисы поднимутся
echo "⏳ Ждём запуска сервисов (20s)..."
sleep 20

# Проверяем состояние сервисов
echo "🏥 Проверяем состояние сервисов..."
docker compose ps

# Выводим доступные URL
IP=$(hostname -I | awk '{print $1}')
echo "✅ DevOps Dashboard успешно развернут!"
echo "   Grafana:        http://$IP:3000"
echo "   Prometheus:     http://$IP:9090"
echo "   cAdvisor:       http://$IP:8080"

