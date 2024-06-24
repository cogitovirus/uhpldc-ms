terraform {
  backend "azurerm" {}
}

resource "azurerm_synapse_workspace" "this" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "ChangeMe123!"  # Use a secure method in production

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "this" {
  name                     = "synapsestorage${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = "synapsefs"
  storage_account_id = azurerm_storage_account.this.id
}
