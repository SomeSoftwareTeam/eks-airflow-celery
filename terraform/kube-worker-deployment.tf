resource "kubernetes_deployment" "worker" {
  metadata {
    name = "worker"
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

        image_pull_secrets {
          name = "regcred"
        }

        container {
          image = "${var.github_docker_registry_url}:${var.docker_image_tag}"
          name  = "worker"

          args = [
          "worker"]

          env {
            name  = "AIRFLOW__CELERY__BROKER_URL"
            value = "amqp://${var.broker_username}:${var.broker_password}@broker.airflow"
          }

          env {
            name  = "AIRFLOW__CELERY__RESULT_BACKEND"
            value = "db+mysql://${aws_db_instance.airflow.username}:${aws_db_instance.airflow.password}@${aws_db_instance.airflow.endpoint}/${aws_db_instance.airflow.name}"
          }

          env {
            name  = "AIRFLOW__CORE__SQL_ALCHEMY_CONN"
            value = "mysql://${aws_db_instance.airflow.username}:${aws_db_instance.airflow.password}@${aws_db_instance.airflow.endpoint}/${aws_db_instance.airflow.name}"
          }

          env {
            name  = "AIRFLOW__FLOWER__BASIC_AUTH"
            value = var.flower_basic_auth
          }

          env {
            name  = "EXECUTOR"
            value = "Celery"
          }

          env {
            name  = "AIRFLOW__CORE__LOAD_EXAMPLES"
            value = var.include_dag_examples
          }

          resources {
            limits {
              cpu    = "2.0"
              memory = "4096Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}