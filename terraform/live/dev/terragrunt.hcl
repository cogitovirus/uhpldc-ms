inputs = {
  resource_group_name = "uhpldc-ms"
  location            = "eastus"
}

terraform {
  backend "azurerm" {
    resource_group_name   = "uhpldc-ms"
    storage_account_name  = "uhpldcmsstorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
