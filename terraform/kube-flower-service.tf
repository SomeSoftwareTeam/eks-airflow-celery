//https://github.com/mher/flower/issues/948
resource "kubernetes_service" "monitor" {
  metadata {
    name      = "monitor"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.monitor.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 5555
    }
    type = "ClusterIP"
  }
}