# Observability Module - Main Configuration

#Prometheus & Grafana 

resource "helm_release" "prometheus_stack" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true
  version          = var.prometheus_stack_version

  # Prometheus configuration
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.prometheus_retention
  }

  set {
    name  = "prometheus.prometheusSpec.scrapeInterval"
    value = var.prometheus_scrape_interval
  }

  # Resource limits for Prometheus
  set {
    name  = "prometheus.prometheusSpec.resources.requests.cpu"
    value = var.prometheus_resources.requests.cpu
  }

  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = var.prometheus_resources.requests.memory
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.cpu"
    value = var.prometheus_resources.limits.cpu
  }

  set {
    name  = "prometheus.prometheusSpec.resources.limits.memory"
    value = var.prometheus_resources.limits.memory
  }

  # Enable service discovery for all namespaces
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  # Grafana configuration
  set {
    name  = "grafana.enabled"
    value = tostring(var.grafana_enabled)
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  set {
    name  = "grafana.service.type"
    value = var.grafana_service_type
  }

  # Resource limits for Grafana
  set {
    name  = "grafana.resources.requests.cpu"
    value = var.grafana_resources.requests.cpu
  }

  set {
    name  = "grafana.resources.requests.memory"
    value = var.grafana_resources.requests.memory
  }

  set {
    name  = "grafana.resources.limits.cpu"
    value = var.grafana_resources.limits.cpu
  }

  set {
    name  = "grafana.resources.limits.memory"
    value = var.grafana_resources.limits.memory
  }

  # AlertManager
  set {
    name  = "alertmanager.enabled"
    value = tostring(var.alertmanager_enabled)
  }

  # Kube State Metrics
  set {
    name  = "kubeStateMetrics.enabled"
    value = tostring(var.kube_state_metrics_enabled)
  }

  # Node Exporter
  set {
    name  = "nodeExporter.enabled"
    value = tostring(var.node_exporter_enabled)
  }

  # Storage configuration
  dynamic "set" {
    for_each = var.prometheus_storage_enabled ? [1] : []
    content {
      name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
      value = var.prometheus_storage_size
    }
  }

  dynamic "set" {
    for_each = var.prometheus_storage_enabled ? [] : [1]
    content {
      name  = "prometheus.prometheusSpec.storageSpec.emptyDir.medium"
      value = ""
    }
  }

  timeout = var.helm_timeout
}
