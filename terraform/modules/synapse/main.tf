# terragrunt-project/modules/synapse/main.tf

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "uhpldc-ms"
    storage_account_name = "uhpldcmsstorage"
    container_name       = "tfstate"
    key                  = "synapse/terraform.tfstate"
  }
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

  blob_properties {
    container_delete_retention_policy {
      days = 7
    }
  }

  enable_https_traffic_only = true
  is_hns_enabled            = true # Enable Hierarchical Namespace (required for Data Lake Gen2)
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "filesystem"
  storage_account_id = azurerm_storage_account.storage_account.id
}

resource "azurerm_synapse_workspace" "synapse_workspace" {
  name                                 = var.synapse_workspace_name
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = azurerm_resource_group.rg.location
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password
  managed_virtual_network_enabled      = true
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
}

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.synapse_workspace.id
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}
