# 1. Le decimos a Terraform que se conecte a mi Kubernetes local
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# 2. Creamos el Deployment (Los Clones)
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
          # Aquí usamos la imagen que se debe de subir a Docker Hub
          image = "rbriceno07/agente-sre:latest"
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

# 3. Creamos el Service (El Portero)
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