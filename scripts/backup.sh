#!/bin/bash

# 💾 Бэкап данных DevOps Dashboard

# Директория для бэкапов с меткой времени
BACKUP_DIR="backups/$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

echo "💾 Создаём бэкап в $BACKUP_DIR..."

# 1. Бэкап конфигураций
cp -r configs/ "$BACKUP_DIR/configs"
echo "✅ Конфигурации сохранены"

# 2. Бэкап данных Grafana из Docker-тома grafana_data
echo "💾 Бэкап данных Grafana..."
docker run --rm \
  -v grafana_data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine \
  tar czf /backup/grafana-data.tar.gz -C /data .
echo "✅ Данные Grafana сохранены: $BACKUP_DIR/grafana-data.tar.gz"

# 3. Бэкап данных Prometheus из Docker-тома prometheus_data
echo "💾 Бэкап данных Prometheus..."
docker run --rm \
  -v prometheus_data:/data \
  -v "$(pwd)/$BACKUP_DIR":/backup \
  alpine \
  tar czf /backup/prometheus-data.tar.gz -C /data .
echo "✅ Данные Prometheus сохранены: $BACKUP_DIR/prometheus-data.tar.gz"

echo "✅ Полный бэкап завершён: $BACKUP_DIR"

