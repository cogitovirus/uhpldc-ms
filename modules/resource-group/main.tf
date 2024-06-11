# terragrunt-project/modules/resource-group/main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
}

variable "name" {}
variable "location" {}

terraform {
  backend "azurerm" {
    resource_group_name   = "uhpldc-ms"
    storage_account_name  = "uhpldcmsstorage"
    container_name        = "tfstate"
    key                   = "path/to/terraform.tfstate"
  }
}
