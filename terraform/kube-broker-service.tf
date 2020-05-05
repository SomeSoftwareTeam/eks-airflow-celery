resource "kubernetes_service" "broker" {
  metadata {
    name      = "broker"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.broker.spec.0.template.0.metadata[0].labels.App
    }
    port {
      name = "https"
      port = 15672
    }
    port {
      name = "amqp"
      port = 5672
    }
    type = "ClusterIP"
  }
}