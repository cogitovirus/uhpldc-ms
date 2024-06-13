# terragrunt-project/live/dev/infrastructure/synapse/terragrunt.hcl
terraform {
  source = "../../../modules/synapse"
}

dependencies {
  paths = ["../"]
}

inputs = {
  resource_group_name              = dependency.resource-group.outputs.resource_group_name
  location                         = dependency.resource-group.outputs.resource_group_location
  synapse_workspace_name           = "dev-synapse-workspace"
  sql_administrator_login          = "adminuser"
  sql_administrator_login_password = "P@ssword1234"
  storage_account_name             = "devsynapsestorageacct"
}

include {
  path = find_in_parent_folders()
}
