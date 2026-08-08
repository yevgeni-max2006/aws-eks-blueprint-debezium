
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
