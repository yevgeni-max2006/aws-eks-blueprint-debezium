
resource "helm_release" "debezium_operator" {
  name             = "debezium-operator"
  repository       = "https://charts.debezium.io"
  chart            = "debezium-operator"
  version          = "3.2.0-final"

  namespace        = "debezium"
  create_namespace = true

  wait    = true
  timeout = 600
  atomic  = true

  cleanup_on_fail = true
}

resource "kubernetes_manifest" "postgres_cdc" {

  manifest = {
    apiVersion = "debezium.io/v1alpha1"
    kind       = "DebeziumServer"

    metadata = {
      name      = "postgres-cdc"
      namespace = "debezium"
    }

    spec = {

      quarkus = {

        config = {

          # Source database
          "debezium.source.connector.class" = "io.debezium.connector.postgresql.PostgresConnector"

          "debezium.source.database.hostname" = "postgres.default.svc.cluster.local"
          "debezium.source.database.port"     = "5432"
          "debezium.source.database.user"     = "debezium"
          "debezium.source.database.password" = "password"
          "debezium.source.database.dbname"   = "app"

          "debezium.source.topic.prefix" = "postgres"


          # Sink Kafka
          "debezium.sink.type" = "kafka"

          "debezium.sink.kafka.bootstrap.servers" = "kafka.kafka.svc.cluster.local:9092"
        }
      }
    }
  }

  depends_on = [
    helm_release.debezium_operator
  ]
}
