output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "location" {
  value = azurerm_resource_group.example.location
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "container_name" {
  value = azurerm_storage_container.example.name
}

output "storage_data_lake_gen2_filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.example.id
}
