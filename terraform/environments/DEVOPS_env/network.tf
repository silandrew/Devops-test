# Network Module
module "network" {
  source = "../../modules/network"

  name_prefix                   = local.name_prefix
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  vnet_name                     = local.vnet_name
  vnet_address_space            = var.vnet_address_space
  subnet_aks_address_prefix     = var.subnet_aks_address_prefix
  subnet_storage_address_prefix = var.subnet_storage_address_prefix
  tags                          = local.common_tags
}
