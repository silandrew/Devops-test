
# Monitoring Module - Outputs


output "workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "workspace_primary_key" {
  description = "Primary shared key"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "workspace_secondary_key" {
  description = "Secondary shared key"
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  sensitive   = true
}
