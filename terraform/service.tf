resource "kubernetes_service" "web_app" {
  metadata {
    name      = "devops-web-app-service"
    namespace = kubernetes_namespace.devops.metadata[0].name
  }

  spec {
    selector = {
      app = "devops-web-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}