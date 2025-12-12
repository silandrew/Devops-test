# =============================================================================
# Observability Module - Variables
# =============================================================================

# =============================================================================
# General Configuration
# =============================================================================

variable "namespace" {
  description = "Kubernetes namespace for observability stack"
  type        = string
  default     = "monitoring"
}

variable "prometheus_stack_version" {
  description = "Version of kube-prometheus-stack Helm chart"
  type        = string
  default     = "56.6.2"
}

variable "helm_timeout" {
  description = "Timeout for Helm release in seconds"
  type        = number
  default     = 600
}

# =============================================================================
# Prometheus Configuration
# =============================================================================

variable "prometheus_retention" {
  description = "How long to retain Prometheus metrics"
  type        = string
  default     = "24h"
}

variable "prometheus_scrape_interval" {
  description = "How often Prometheus scrapes targets"
  type        = string
  default     = "30s"
}

variable "prometheus_resources" {
  description = "Resource requests and limits for Prometheus"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }
}

variable "prometheus_storage_enabled" {
  description = "Enable persistent storage for Prometheus"
  type        = bool
  default     = false
}

variable "prometheus_storage_size" {
  description = "Storage size for Prometheus (if enabled)"
  type        = string
  default     = "10Gi"
}

# =============================================================================
# Grafana Configuration
# =============================================================================

variable "grafana_enabled" {
  description = "Enable Grafana deployment"
  type        = bool
  default     = true
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
  default     = "admin123!"
}

variable "grafana_service_type" {
  description = "Service type for Grafana (ClusterIP, LoadBalancer, NodePort)"
  type        = string
  default     = "LoadBalancer"
}

variable "grafana_resources" {
  description = "Resource requests and limits for Grafana"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "50m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
  }
}

# =============================================================================
# Component Toggles
# =============================================================================

variable "alertmanager_enabled" {
  description = "Enable AlertManager"
  type        = bool
  default     = true
}

variable "kube_state_metrics_enabled" {
  description = "Enable Kube State Metrics"
  type        = bool
  default     = true
}

variable "node_exporter_enabled" {
  description = "Enable Node Exporter"
  type        = bool
  default     = true
}

# =============================================================================
# Ingress Configuration
# =============================================================================

variable "grafana_ingress_enabled" {
  description = "Enable ingress for Grafana"
  type        = bool
  default     = true
}

variable "grafana_ingress_class" {
  description = "Ingress class for Grafana"
  type        = string
  default     = "nginx"
}

variable "grafana_ingress_path" {
  description = "Ingress path for Grafana"
  type        = string
  default     = "/"
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
