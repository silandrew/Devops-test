
# ACR Module - Variables


variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "acr_name" {
  description = "Name of the ACR (must be globally unique)"
  type        = string
}

variable "acr_sku" {
  description = "SKU for ACR (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = true
}

variable "acr_public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "acr_georeplication_locations" {
  description = "Geo-replication locations (Premium only)"
  type        = list(string)
  default     = []
}

variable "acr_retention_policy_days" {
  description = "Retention policy days (Premium only)"
  type        = number
  default     = 7
}

variable "aks_kubelet_identity_object_id" {
  description = "AKS kubelet identity object ID for ACR pull"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
