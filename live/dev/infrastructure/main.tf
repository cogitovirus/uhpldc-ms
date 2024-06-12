# terragrunt-project/live/dev/infrastructure/main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
}

terraform {
  backend "azurerm" {}
}
