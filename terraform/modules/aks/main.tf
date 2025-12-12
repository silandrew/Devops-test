
# AKS Module - Main Configuration


resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.aks_sku_tier

 
  # Default (System) Node Pool

  default_node_pool {
    name                         = var.system_node_pool_name
    vm_size                      = var.system_node_vm_size
    os_disk_size_gb              = var.system_node_os_disk_size_gb
    vnet_subnet_id               = var.subnet_aks_id
    type                         = "VirtualMachineScaleSets"
    auto_scaling_enabled         = true
    min_count                    = var.system_node_min_count
    max_count                    = var.system_node_max_count
    node_count                   = var.system_node_count

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
    }

    tags = var.tags
  }

  
  # Identity
  
  identity {
    type = "SystemAssigned"
  }

  
  # Network Profile
  
  network_profile {
    network_plugin    = var.aks_network_plugin
    network_policy    = var.aks_network_policy
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }


  # Azure Monitor (Container Insights)
  
  dynamic "oms_agent" {
    for_each = var.enable_container_insights && var.log_analytics_workspace_id != "" ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  
  # Add-ons and Features
 
  azure_policy_enabled             = var.aks_azure_policy_enabled
  http_application_routing_enabled = var.aks_http_application_routing_enabled

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"],
      default_node_pool[0].node_count
    ]
  }
}


# User Node Pool (Application Workloads)


resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  os_disk_size_gb       = var.user_node_os_disk_size_gb
  vnet_subnet_id        = var.subnet_aks_id
  auto_scaling_enabled  = true
  min_count             = var.user_node_min_count
  max_count             = var.user_node_max_count
  mode                  = "User"

  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "workload"      = "application"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedAt"],
      node_count
    ]
  }
}


# AKS Cluster Role Assignment - Network Contributor


resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id                     = azurerm_kubernetes_cluster.main.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                            = var.vnet_id
  skip_service_principal_aad_check = true
}
