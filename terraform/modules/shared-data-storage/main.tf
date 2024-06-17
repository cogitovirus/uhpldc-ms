provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
  is_hns_enabled            = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "filesystem"
  storage_account_id = azurerm_storage_account.storage_account.id
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "storage_data_lake_gen2_filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.example.id
}
