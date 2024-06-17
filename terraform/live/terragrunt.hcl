remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "uhpldc-ms"
    storage_account_name = "uhpldcmsstorage"
    container_name       = "tfstate"
    key                  = "global/terraform.tfstate"
  }
}

inputs = {
  resource_group_name = "uhpldc-ms"
  location            = "eastus"
}
