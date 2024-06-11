provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
}

terraform {
  backend "azurerm" {
    resource_group_name  = "uhpldc-ms"
    storage_account_name = "uhpldcmsstorage"
    container_name       = "tfstate"
    key                  = "resource-group/terraform.tfstate"
  }
}
