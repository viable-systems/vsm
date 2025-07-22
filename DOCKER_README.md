# 🐳 VSM Docker Deployment Guide

## Quick Start (Development)

```bash
# Clone the VSM ecosystem
git clone https://github.com/viable-systems/vsm.git
cd vsm

# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# Enter the container and run all 12 modules
docker-compose -f docker-compose.dev.yml exec vsm_dev iex -S mix
```

## Production Deployment

### 1. Using Pre-built Image (Recommended)

```bash
# Pull the official VSM image
docker pull viablesystems/vsm:latest

# Run with minimal config
docker run -p 4000:4000 -p 4040:4040 viablesystems/vsm:latest
```

### 2. Using Docker Compose (Full Stack)

```bash
# Start all services (VSM, PostgreSQL, Redis, Prometheus, Grafana)
docker-compose up -d

# View logs
docker-compose logs -f vsm

# Access services:
# - API: http://localhost:4000
# - Telemetry: http://localhost:4040
# - Grafana: http://localhost:3000 (admin/admin)
# - Prometheus: http://localhost:9090
```

### 3. Building Custom Image

```bash
# Build the image
docker build -t vsm:custom .

# Run with environment variables
docker run -d \
  -p 4000:4000 \
  -p 4040:4040 \
  -e PHX_HOST=myserver.com \
  -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
  vsm:custom
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection | Required in production |
| `REDIS_URL` | Redis connection | Optional |
| `SECRET_KEY_BASE` | Phoenix secret | Required in production |
| `PHX_HOST` | Public hostname | localhost |
| `VSM_CORE_SYSTEMS` | Active systems | production_plant |
| `VSM_PATTERN_ENGINE_ENABLED` | Enable pattern detection | true |
| `VSM_SECURITY_Z3N_ENABLED` | Enable Z3N security | true |

### Ports

- `4000` - REST API & External Interfaces
- `4001` - WebSocket connections
- `4040` - Telemetry Dashboard
- `50051` - gRPC interface

## Docker Compose Profiles

```bash
# Run with vector store
docker-compose --profile vector up -d

# Run with analytics
docker-compose --profile analytics up -d

# Run everything
docker-compose --profile vector --profile analytics up -d
```

## Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vsm-ecosystem
spec:
  replicas: 3
  selector:
    matchLabels:
      app: vsm
  template:
    metadata:
      labels:
        app: vsm
    spec:
      containers:
      - name: vsm
        image: viablesystems/vsm:latest
        ports:
        - containerPort: 4000
        - containerPort: 4040
        env:
        - name: PHX_HOST
          value: vsm.example.com
        - name: SECRET_KEY_BASE
          valueFrom:
            secretKeyRef:
              name: vsm-secrets
              key: secret-key-base
```

## Health Checks

The VSM container includes health checks:

```bash
# Check if services are healthy
docker-compose ps

# Manual health check
curl http://localhost:4000/health
```

## Scaling

```bash
# Scale VSM instances
docker-compose up -d --scale vsm=3

# With Docker Swarm
docker service create \
  --name vsm \
  --replicas 5 \
  -p 4000:4000 \
  viablesystems/vsm:latest
```

## Monitoring

Access monitoring dashboards:
- **Grafana**: http://localhost:3000
  - Username: admin
  - Password: admin
  - Pre-configured VSM dashboards

- **Prometheus**: http://localhost:9090
  - Query VSM metrics
  - Alert configuration

## Troubleshooting

### View logs
```bash
docker-compose logs -f vsm
```

### Enter container
```bash
docker-compose exec vsm sh
```

### Reset everything
```bash
docker-compose down -v
docker-compose up -d
```

## Security Considerations

1. **Change default passwords** in production
2. **Use secrets management** for sensitive data
3. **Enable TLS/SSL** for external connections
4. **Restrict port exposure** as needed
5. **Regular image updates** for security patches

## CI/CD Integration

```yaml
# GitHub Actions example
name: Deploy VSM
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build and push
      run: |
        docker build -t vsm:${{ github.sha }} .
        docker push vsm:${{ github.sha }}
    - name: Deploy
      run: |
        docker service update --image vsm:${{ github.sha }} vsm
```

---

**Ready to deploy the complete 12-module VSM ecosystem with Docker! 🚀**