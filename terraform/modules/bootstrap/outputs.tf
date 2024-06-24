output "resource_group_name" {
  value       = azurerm_resource_group.tfstate.name
  description = "The name of the resource group"
}

output "resource_group_id" {
  value       = azurerm_resource_group.tfstate.id
  description = "The ID of the resource group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "The name of the storage account"
}

output "storage_account_id" {
  value       = azurerm_storage_account.tfstate.id
  description = "The ID of the storage account"
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.tfstate.primary_access_key
  description = "The primary access key for the storage account"
  sensitive   = true
}

output "storage_container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "The name of the storage container"
}

output "storage_container_id" {
  value       = azurerm_storage_container.tfstate.id
  description = "The ID of the storage container"
}