
resource "kubernetes_namespace" "postgres" {
  metadata {
    name = "postgres"
  }
}

resource "helm_release" "postgres" {
  name       = "postgres"
  namespace  = kubernetes_namespace.postgres.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "16.4.6"

  values = [
    yamlencode({
      auth = {
        postgresPassword = "postgres"

        username = "debezium"
        password = "debezium"
        database = "app"
      }

      primary = {
        persistence = {
          enabled = true
          size    = "10Gi"
        }

        extendedConfiguration = <<-EOF
          wal_level = logical
          max_wal_senders = 10
          max_replication_slots = 10
        EOF
      }
    })
  ]

  wait    = true
  timeout = 600
}
