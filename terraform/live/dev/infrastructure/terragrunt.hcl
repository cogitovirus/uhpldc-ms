terraform {
  source = "../../../modules/core-infrastructure//"
}

inputs = {
  name                 = "uhpldc-ms"
  location             = "eastus"
  container_name       = "tfstate"
  storage_account_name = "uhpldcmsstorage"
  key                  = "infrastructure/terraform.tfstate"
  prefix               = "dev"
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "uhpldc-ms"
    storage_account_name = "uhpldcmsstorage"
    container_name       = "tfstate"
    key                  = "infrastructure/terraform.tfstate"
  }
}

include {
  path = "../../terragrunt.hcl"
}
