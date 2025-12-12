# =============================================================================
# Network Module - Outputs
# =============================================================================

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_aks_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "subnet_aks_name" {
  description = "Name of the AKS subnet"
  value       = azurerm_subnet.aks.name
}

output "subnet_storage_id" {
  description = "ID of the storage subnet"
  value       = azurerm_subnet.storage.id
}

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.aks.id
}

output "nsg_association_id" {
  description = "ID of the NSG association"
  value       = azurerm_subnet_network_security_group_association.aks.id
}
