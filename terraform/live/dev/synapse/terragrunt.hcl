dependency "shared" {
  config_path = "../infrastructure"
}

terraform {
  source = "../../../modules/synapse//"

  backend "azurerm" {
    resource_group_name   = "uhpldc-ms"
    storage_account_name  = "uhpldcmsstorage"
    container_name        = "tfstate"
    key                   = "synapse/terraform.tfstate"
  }
}

inputs = {
  container_name                       = "tfstate"
  storage_account_name                 = "uhpldcmsstorage"
  key                                  = "synapse/terraform.tfstate"
  resource_group_name                  = dependency.shared.outputs.resource_group_name
  location                             = dependency.shared.outputs.location
  synapse_workspace_name               = "dev-synapse-workspace"
  sql_administrator_login              = "adminuser"
  sql_administrator_login_password     = "P@ssword1234"
  storage_data_lake_gen2_filesystem_id = dependency.shared.outputs.storage_data_lake_gen2_filesystem_id
}

include {
  path = find_in_parent_folders()
}
