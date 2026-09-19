resource "kubernetes_deployment" "web_app" {
  metadata {
    name      = "devops-web-app"
    namespace = kubernetes_namespace.devops.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "devops-web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "devops-web-app"
        }
      }

      spec {
        container {
          name  = "web-app"
          image = "devops-web-app:2.0"

          image_pull_policy = "Never"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}