
resource "helm_release" "debezium_operator" {
  name       = "debezium-operator"
  repository = "https://charts.debezium.io"
  chart      = "debezium-operator"
  version    = "3.2.0-final"

  namespace        = "debezium"
  create_namespace = true

  wait            = true
  timeout         = 600
  atomic          = true
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
          # PostgreSQL source
          "debezium.source.connector.class" = "io.debezium.connector.postgresql.PostgresConnector"

          "debezium.source.database.hostname" = "postgres.default.svc.cluster.local"
          "debezium.source.database.port"     = "5432"
          "debezium.source.database.user"     = "debezium"
          "debezium.source.database.password" = "ebezium"
          "debezium.source.database.dbname"   = "app"

          "debezium.source.topic.prefix" = "postgres"

          # Kafka sink
          "debezium.sink.type" = "kafka"
          "debezium.sink.kafka.bootstrap.servers" = "kafka.kafka.svc.cluster.local:9092"

          # Recommended PostgreSQL CDC settings
          "debezium.source.plugin.name" = "pgoutput"
          "debezium.source.slot.name"    = "debezium_slot"
          "debezium.source.publication.name" = "debezium_publication"

          # Initial snapshot
          "debezium.source.snapshot.mode" = "initial"
        }
      }
    }
  }

  depends_on = [
    helm_release.debezium_operator
  ]
}
