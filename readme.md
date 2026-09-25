# 🚀 Agente SRE - Cloud-Native Automation & Observability

Proyecto de arquitectura para simular el ciclo de vida completo de un entorno **Site Reliability Engineering (SRE)** usando prácticas de Infraestructura como Código (IaC), Observabilidad y Microservicios.

## 🛠️ Arquitectura y Tecnologías
* **Lenguaje:** Python (FastAPI, `boto3`, `psutil`)
* **Contenedores y Orchestration:** Docker, Kubernetes (Minikube / Docker Desktop)
* **Infraestructura como Código (IaC):** Terraform (Proveedores AWS y Kubernetes)
* **Observabilidad:** Prometheus & Grafana (desplegados mediante Helm Stack)
* **CI/CD:** GitHub Actions para pruebas e integración continua
* **Cloud Storage:** S3 (Emulado localmente con MinIO)

## 📌 Funcionalidades Principales
1. **Despliegue Automatizado:** Declaración de la infraestructura completa en Terraform (`main.tf`).
2. **Observabilidad en Tiempo Real:** Monitorización de recursos de pods y métricas de clúster con Grafana.
3. **Agente de Diagnóstico:** Endpoint inteligente que captura métricas del sistema y persiste reportes JSON en almacenamiento de objetos en la nube (S3).

## 🚀 Cómo Ejecutar Localmente
```bash
# 1. Levantar almacenamiento S3 local
docker run -d -p 9000:9000 -p 9001:9001 --name nube-local -e "MINIO_ROOT_USER=test" -e "MINIO_ROOT_PASSWORD=testpassword" cgr.dev/chainguard/minio server /data --console-address ":9001"

# 2. Desplegar Infraestructura con Terraform
terraform init
terraform apply -auto-approve

# 3. Iniciar el Agente
uvicorn main:app --port 8000