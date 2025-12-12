# Observability Stack (Prometheus & Grafana)
module "observability" {
  source = "../../modules/observability"

  namespace                = "monitoring"
  prometheus_stack_version = "56.6.2"

  # Prometheus settings
  prometheus_retention       = "24h"
  prometheus_scrape_interval = "30s"
  prometheus_storage_enabled = false  # Use emptyDir for homework

  prometheus_resources = {
    requests = {
      cpu    = "100m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  # Grafana settings
  grafana_enabled         = true
  grafana_admin_password  = var.grafana_admin_password
  grafana_service_type    = "LoadBalancer"
  grafana_ingress_enabled = false  # Using LoadBalancer, no ingress needed

  grafana_resources = {
    requests = {
      cpu    = "50m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
  }

  # Component toggles
  alertmanager_enabled       = true
  kube_state_metrics_enabled = true
  node_exporter_enabled      = true

  tags = local.common_tags

  depends_on = [
    module.aks,
    helm_release.nginx_ingress
  ]
}

# ServiceMonitor for DevOps App
resource "kubernetes_manifest" "app_service_monitor" {
  count = var.deploy_app_service_monitor ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "devops-app-monitor"
      namespace = "monitoring"
      labels = {
        app     = "devops-app"
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "devops-app"
        }
      }
      namespaceSelector = {
        matchNames = [var.app_namespace]
      }
      endpoints = [
        {
          port     = "http"
          path     = "/metrics"
          interval = "30s"
        }
      ]
    }
  }

  depends_on = [module.observability]
}
