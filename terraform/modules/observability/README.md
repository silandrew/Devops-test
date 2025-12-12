# =============================================================================
# Observability Module
# =============================================================================
# Deploys a complete observability stack using kube-prometheus-stack
#
# Components:
# - Prometheus: Metrics collection and storage
# - Grafana: Visualization and dashboards
# - AlertManager: Alert routing and notifications
# - Kube State Metrics: Kubernetes object metrics
# - Node Exporter: Node-level metrics
#
# Usage:
#   module "observability" {
#     source = "../../modules/observability"
#
#     namespace              = "monitoring"
#     grafana_admin_password = var.grafana_admin_password
#     grafana_service_type   = "LoadBalancer"
#
#     prometheus_resources = {
#       requests = { cpu = "100m", memory = "256Mi" }
#       limits   = { cpu = "500m", memory = "512Mi" }
#     }
#   }
#
# Accessing Grafana:
#   1. Get external IP: kubectl get svc -n monitoring prometheus-grafana
#   2. Login: admin / <grafana_admin_password>
#
# Accessing Prometheus (port-forward):
#   kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
#
# =============================================================================
