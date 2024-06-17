provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.storage_account.id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "location" {
  value = azurerm_resource_group.main.location
}

output "storage_data_lake_gen2_filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.example.id
}
