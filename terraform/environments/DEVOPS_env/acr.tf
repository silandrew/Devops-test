# ACR Module
module "acr" {
  source = "../../modules/acr"

  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  acr_name                          = local.acr_name
  acr_sku                           = var.acr_sku
  acr_admin_enabled                 = var.acr_admin_enabled
  acr_public_network_access_enabled = var.acr_public_network_access_enabled
  acr_georeplication_locations      = var.acr_georeplication_locations
  acr_retention_policy_days         = var.acr_retention_policy_days
  aks_kubelet_identity_object_id    = module.aks.kubelet_identity_object_id
  tags                              = local.common_tags

  depends_on = [module.aks]
}
