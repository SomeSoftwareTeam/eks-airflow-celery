resource "kubernetes_ingress" "airflow" {
  metadata {
    name      = "airflow"
    namespace = kubernetes_namespace.airflow.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/success-codes"   = "200-399"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\":80}]"
    }
  }
  spec {
    rule {
      host = "airflow.somesoftwareteam.com"
      http {
        path {
          backend {
            service_name = kubernetes_service.webserver.metadata[0].name
            service_port = 8080
          }
        }
      }
    }
    rule {
      host = "flower.somesoftwareteam.com"
      http {
        path {
          backend {
            service_name = kubernetes_service.monitor.metadata[0].name
            service_port = 5555
          }
        }
      }
    }
    rule {
      host = "broker.somesoftwareteam.com"
      http {
        path {
          backend {
            service_name = kubernetes_service.broker.metadata[0].name
            service_port = 15672
          }
        }
      }
    }
  }
}