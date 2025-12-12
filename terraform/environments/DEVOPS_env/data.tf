# =============================================================================
# DEVOPS Environment - Data Sources
# =============================================================================

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}
