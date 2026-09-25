# 0. Definición de proveedores requeridos
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Conexión al Kubernetes local
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# 2. Conexión al simulador de nube (AWS S3 vía MinIO)
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "testpassword"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  # Los endpoints VAN DENTRO del bloque del provider:
  endpoints {
    s3 = "http://localhost:9005"
  }
}

# 3. Deployment de Kubernetes (Los Clones)
resource "kubernetes_deployment" "prometeo_deployment" {
  metadata {
    name = "prometeo-deployment-tf"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "prometeo"
      }
    }
    template {
      metadata {
        labels = {
          app = "prometeo"
        }
      }
      spec {
        container {
          name  = "agente-contenedor"
          image = "rbriceno07/agente-sre:latest"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

# 4. Service de Kubernetes (El Portero)
resource "kubernetes_service" "prometeo_service" {
  metadata {
    name = "prometeo-service-tf"
  }
  spec {
    selector = {
      app = "prometeo"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}

# 5. Recurso de AWS (Bucket de almacenamiento en la nube simulada)
resource "aws_s3_bucket" "almacen_prometeo" {
  bucket = "prometeo-datos-bucket"
}