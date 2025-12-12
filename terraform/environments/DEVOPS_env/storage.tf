# Storage Module
module "storage" {
  source = "../../modules/storage"

  resource_group_name                     = azurerm_resource_group.main.name
  location                                = azurerm_resource_group.main.location
  storage_name                            = local.storage_name
  storage_account_tier                    = var.storage_account_tier
  storage_account_replication_type        = var.storage_account_replication_type
  storage_account_kind                    = var.storage_account_kind
  storage_min_tls_version                 = var.storage_min_tls_version
  storage_enable_https_traffic_only       = var.storage_enable_https_traffic_only
  storage_blob_delete_retention_days      = var.storage_blob_delete_retention_days
  storage_container_delete_retention_days = var.storage_container_delete_retention_days
  create_storage_containers               = var.create_storage_containers
  storage_containers                      = var.storage_containers
  subnet_aks_id                           = module.network.subnet_aks_id
  aks_kubelet_identity_object_id          = module.aks.kubelet_identity_object_id
  tags                                    = local.common_tags

  depends_on = [module.aks, module.network]
}
