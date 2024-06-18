dependency "infrastructure" {
  config_path = "../infrastructure"

  mock_outputs = {
    resource_group_name                  = "uhpldc-ms"
    storage_account_name                 = "uhpldcmsstorage"
    container_name                       = "tfstate"
    location                             = "eastus"
    storage_data_lake_gen2_filesystem_id = "mock-filesystem-id"
  }

  # Uncomment this line if you have applied the infrastructure module and it should not skip outputs
  skip_outputs = false
}

terraform {
  source = "../../../modules/synapse//"
}

inputs = {
  resource_group_name                  = dependency.infrastructure.outputs.resource_group_name
  storage_account_name                 = dependency.infrastructure.outputs.storage_account_name
  container_name                       = dependency.infrastructure.outputs.container_name
  location                             = dependency.infrastructure.outputs.location
  synapse_workspace_name               = "dev-synapse-workspace"
  sql_administrator_login              = "adminuser"
  sql_administrator_login_password     = "P@ssword1234"
  storage_data_lake_gen2_filesystem_id = dependency.infrastructure.outputs.storage_data_lake_gen2_filesystem_id
}

include {
  path = "../../terragrunt.hcl"
}
