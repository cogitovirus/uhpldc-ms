# terragrunt-project/live/dev/synapse/terragrunt.hcl

dependency "shared" {
  config_path = "../infrastructure"
}

terraform {
  source = "../../../modules/synapse"
}

inputs = {
  resource_group_name                  = dependency.storage_account.outputs.resource_group_name
  location                             = dependency.storage_account.outputs.location
  synapse_workspace_name               = "dev-synapse-workspace"
  sql_administrator_login              = "adminuser"
  sql_administrator_login_password     = "P@ssword1234"
  storage_data_lake_gen2_filesystem_id = dependency.storage_account.outputs.storage_data_lake_gen2_filesystem_id
}

include {
  path = find_in_parent_folders()
}
