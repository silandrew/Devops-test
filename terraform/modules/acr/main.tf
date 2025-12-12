
# ACR Module - Main Configuration

resource "azurerm_container_registry" "main" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  public_network_access_enabled = var.acr_public_network_access_enabled

  # Premium SKU features
  dynamic "georeplications" {
    for_each = var.acr_sku == "Premium" ? var.acr_georeplication_locations : []
    content {
      location                = georeplications.value
      zone_redundancy_enabled = true
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedAt"]]
  }
}

# ACR Role Assignment - Allow AKS to pull images


resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = var.aks_kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}
