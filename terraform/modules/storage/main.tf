
# Storage Module - Main Configuration


resource "azurerm_storage_account" "main" {
  name                         = var.storage_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  account_tier                 = var.storage_account_tier
  account_replication_type     = var.storage_account_replication_type
  account_kind                 = var.storage_account_kind
  min_tls_version              = var.storage_min_tls_version
  https_traffic_only_enabled   = var.storage_enable_https_traffic_only

  # Blob properties
  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_delete_retention_days
    }
    versioning_enabled = true
  }

  # Network rules
  dynamic "network_rules" {
    for_each = var.subnet_aks_id != "" ? [1] : []
    content {
      default_action             = "Allow"
      bypass                     = ["AzureServices"]
      virtual_network_subnet_ids = [var.subnet_aks_id]
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}


# Storage Containers


resource "azurerm_storage_container" "containers" {
  for_each = var.create_storage_containers ? {
    for container in var.storage_containers : container.name => container
  } : {}

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.container_access_type
}


# Storage Account Role Assignment 


resource "azurerm_role_assignment" "aks_storage_contributor" {
  principal_id                     = var.aks_kubelet_identity_object_id
  role_definition_name             = "Storage Blob Data Contributor"
  scope                            = azurerm_storage_account.main.id
  skip_service_principal_aad_check = true
}
