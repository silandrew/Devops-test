# AKS Module
module "aks" {
  source = "../../modules/aks"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment

  # Cluster configuration
  aks_name           = local.aks_name
  aks_dns_prefix     = local.aks_dns_prefix
  kubernetes_version = var.kubernetes_version
  aks_sku_tier       = var.aks_sku_tier

  # Network configuration
  subnet_aks_id      = module.network.subnet_aks_id
  vnet_id            = module.network.vnet_id
  aks_network_plugin = var.aks_network_plugin
  aks_network_policy = var.aks_network_policy
  service_cidr       = var.service_cidr
  dns_service_ip     = var.dns_service_ip

  # System node pool
  system_node_pool_name       = var.system_node_pool_name
  system_node_count           = var.system_node_count
  system_node_min_count       = var.system_node_min_count
  system_node_max_count       = var.system_node_max_count
  system_node_vm_size         = var.system_node_vm_size
  system_node_os_disk_size_gb = var.system_node_os_disk_size_gb

  # User node pool
  user_node_pool_name       = var.user_node_pool_name
  user_node_count           = var.user_node_count
  user_node_min_count       = var.user_node_min_count
  user_node_max_count       = var.user_node_max_count
  user_node_vm_size         = var.user_node_vm_size
  user_node_os_disk_size_gb = var.user_node_os_disk_size_gb

  # Add-ons
  aks_azure_policy_enabled             = var.aks_azure_policy_enabled
  aks_http_application_routing_enabled = var.aks_http_application_routing_enabled
  aks_automatic_channel_upgrade        = var.aks_automatic_channel_upgrade

  # Monitoring
  enable_container_insights  = var.enable_container_insights
  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = local.common_tags

  depends_on = [module.network]
}
