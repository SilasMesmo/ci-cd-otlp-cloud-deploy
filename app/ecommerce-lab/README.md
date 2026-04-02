# DevShop - eCommerce Lab Application

Uma aplicação completa de e-commerce em Python desenhada especificamente para testes de infraestrutura e deployment no Kubernetes (Liveness, Readiness, Rollouts).

## Contexto de Uso
A aplicação foi desenvolvida para os laboratórios de DevOps e SRE:
- Deployments Kubernetes e testes simplificados
- Testes de Ingress e LoadBalancer
- Testes de Scaling, Rollouts e Rollbacks
- Health checks (LivenessProbe / ReadinessProbe) simulando falhas.

## Requisitos Técnicos
- Python 3.11+
- FastAPI, SQLAlchemy, SQLite em memória
- Vanilla HTML / CSS / JS

## Execução Local (Docker)

```bash
docker build -t ecommerce-lab .
docker run -p 8080:8080 \
  -e APP_VERSION="v1.0.0" \
  -e ENVIRONMENT="staging" \
  ecommerce-lab
```

Acesso: [http://localhost:8080](http://localhost:8080)

## Simulação de Falhas (Health Check)
Para simular um erro `500` nos probes de Liveness/Readiness, ative a variável de ambiente:
```bash
docker run -p 8080:8080 -e SIMULATE_FAILURE=true ecommerce-lab
```
O endpoint `/health` validará esse comportamento.
