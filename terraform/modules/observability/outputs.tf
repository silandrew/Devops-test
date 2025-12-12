# =============================================================================
# Observability Module - Outputs
# =============================================================================

output "namespace" {
  description = "Namespace where observability stack is deployed"
  value       = var.namespace
}

output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = "prometheus-kube-prometheus-prometheus"
}

output "prometheus_url" {
  description = "Internal Prometheus URL"
  value       = "http://prometheus-kube-prometheus-prometheus.${var.namespace}:9090"
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = "prometheus-grafana"
}

output "grafana_url_command" {
  description = "Command to get Grafana external URL"
  value       = "kubectl get svc -n ${var.namespace} prometheus-grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}

output "grafana_credentials" {
  description = "Grafana login info"
  value = {
    username = "admin"
    password = "Set via var.grafana_admin_password"
  }
}

output "alertmanager_url" {
  description = "Internal AlertManager URL"
  value       = var.alertmanager_enabled ? "http://prometheus-kube-prometheus-alertmanager.${var.namespace}:9093" : null
}

output "helm_release_name" {
  description = "Helm release name"
  value       = helm_release.prometheus_stack.name
}

output "helm_release_status" {
  description = "Helm release status"
  value       = helm_release.prometheus_stack.status
}
