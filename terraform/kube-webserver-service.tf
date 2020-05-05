resource "kubernetes_service" "webserver" {
  metadata {
    name      = "webserver"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.webserver.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 8080
    }
    type = "ClusterIP"
  }
}