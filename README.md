# DevOps Dashboard
Мониторинговый стек с Prometheus, Grafana, Node Exporter, cAdvisor и Process Exporter в Docker Compose.

## Содержание
- Требования
- Структура проекта
- Быстрый старт
- Конфигурация
- Запуск и проверка
- Создание и импорт дашбордов
- Скрипты автоматизации
- Резервное копирование

## Требования
- Docker Engine (>=20.10)
- Docker Compose v2 (плагин `docker compose`)
- Git

## Структура проекта
```
devops-dashboard/
├── configs/  
│   ├── grafana/  
│   │   ├── dashboards/        # Provisioned dashboards  
│   │   │   └── dashboard.yml  
│   │   ├── datasources/       # Provisioned datasources  
│   │   │   └── prometheus.yml  
│   │   └── grafana.ini        # Основные настройки Grafana  
│   └── prometheus/  
│       ├── prometheus.yml     # Конфиг Prometheus  
│       ├── rules/             # Правила alerting
│       └── process-exporter.yml
├── docker-compose.yml         # Описание сервисов и томов  
├── scripts/  
│   ├── deploy.sh              # Развёртывание стека  
│   └── backup.sh              # Резервное копирование  
└── docs/                      # Скриншоты и документация
```

## Быстрый старт
1. Склонировать репозиторий:
   git clone https://github.com/<ваш-пользователь>/devops-dashboard.git
   cd devops-dashboard
2. Подготовить скрипты:
   chmod +x scripts/deploy.sh scripts/backup.sh

## Конфигурация
- **Prometheus**: `configs/prometheus/prometheus.yml` и папка `configs/prometheus/rules`
- **Grafana**:
  - Основные настройки: `configs/grafana/grafana.ini`
  - Provisioned Datasource: `configs/grafana/datasources/prometheus.yml`
  - Provisioned Dashboards: папка `configs/grafana/dashboards`
- **Node Exporter**, **cAdvisor**, **Process Exporter** заданы в `docker-compose.yml`

## Запуск и проверка
1. Развернуть стек:
   sudo ./scripts/deploy.sh
2. Убедиться, что сервисы запущены:
   docker compose ps
3. Открыть в браузере:
   - Grafana: http://<HOST_IP>:3000 (admin/admin123)
   - Prometheus: http://<HOST_IP>:9090
   - cAdvisor: http://<HOST_IP>:8080

## Создание и импорт дашбордов
1. Импорт готовых дашбордов в Grafana:
   - Dashboards → New → Import
   - Ввести ID из grafana.com (например, Node Exporter Full, Docker Container & Host Metrics и Prometheus Stats)
2. Создать кастомный дашборд **DevOps Overview**:
   - Dashboards → New Dashboard → Add new panel
   - CPU Usage (Gauge): ```promql
     100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
     ```
   - Memory Usage (Gauge): ```promql
     (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
     ```
   - Docker Containers (Stat): ```promql
     count(container_last_seen)
     ```
   - Сохранить и переименовать панели в **CPU Usage**, **Memory Usage**, **Docker Containers**.

## Скрипты автоматизации
- **deploy.sh** — полный развёртывание стека:
  - Проверка Docker, остановка старых контейнеров, запуск новых, вывод URL
- **backup.sh** — резервное копирование:
  - Сохраняет `configs/` и данные из томов `grafana_data` и `prometheus_data` в timestamp-папку `backups/`

## Резервное копирование
Запустить:
./scripts/backup.sh
Результаты будут в папке `backups/<YYYY-MM-DD_HH-MM-SS>/`:
- `configs/`
- `grafana-data.tar.gz`
- `prometheus-data.tar.gz`

# devops-dashboard
“Docker Compose мониторинг: Prometheus, Grafana, Node Exporter, cAdvisor, Process Exporter”
