resource "kubernetes_deployment" "broker" {
  metadata {
    name = "broker"
    labels = {
      App = "airflow"
    }
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "airflow"
      }
    }
    template {
      metadata {
        labels = {
          App = "airflow"
        }
      }

      spec {

        container {
          image = "docker.io/library/rabbitmq:3-management"
          name  = "broker"

          port {
            container_port = 15672
          }

          port {
            container_port = 5672
          }
        }
      }
    }
  }
}