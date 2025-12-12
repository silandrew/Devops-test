# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  log_analytics_name           = local.log_analytics_name
  log_analytics_sku            = var.log_analytics_sku
  log_analytics_retention_days = var.log_analytics_retention_days
  enable_container_insights    = var.enable_container_insights
  tags                         = local.common_tags
}
