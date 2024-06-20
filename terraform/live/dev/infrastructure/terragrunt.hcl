terraform {
  source = "../../../modules/core-infrastructure//"
}

dependency "bootstrap" {
  config_path = "../bootstrap//"
  mock_outputs = {
    resource_group_name = "uhpldc-ms-rg"
  }
}

inputs = {
  name                 = "uhpldc-ms"
  location             = "eastus"
  container_name       = "tfstate"
  storage_account_name = "uhpldcmsstorage"
  key                  = "infrastructure/terraform.tfstate"
  prefix               = "dev"
  resource_group_name  = dependency.bootstrap.outputs.resource_group_name
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
