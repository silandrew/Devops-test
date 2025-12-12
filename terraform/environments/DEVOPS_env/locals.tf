# =============================================================================
# DEVOPS Environment - Local Variables
# =============================================================================

locals {
  # Resource naming convention: {project}-{environment}-{resource}
  name_prefix = "${var.project_name}-${var.environment}"
  
  # Alphanumeric only name (for ACR/Storage - no hyphens allowed)
  name_alphanumeric = replace("${var.project_name}${var.environment}", "-", "")
  
  # Shortened name for storage (max 24 chars)
  name_short = substr(local.name_alphanumeric, 0, min(length(local.name_alphanumeric), 12))

  # Common tags for all resources
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
      CreatedAt   = timestamp()
    },
    var.tags
  )

  # Resource names
  aks_name           = "${local.name_prefix}-aks"
  aks_dns_prefix     = "${var.project_name}-${var.environment}"
  vnet_name          = "${local.name_prefix}-vnet"
  acr_name           = local.name_alphanumeric
  storage_name       = "${local.name_short}st${random_string.suffix.result}"
  log_analytics_name = "${local.name_prefix}-logs"
}
