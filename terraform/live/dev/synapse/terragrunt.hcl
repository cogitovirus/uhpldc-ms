# /Users/wiktor/Projects/uhpldc-ms/terraform/live/dev/synapse/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

dependency "bootstrap" {
  config_path = "../bootstrap"
}

locals {
  env     = include.root.locals.env
  project = include.root.locals.project
}

inputs = {
  resource_group_name     = dependency.bootstrap.outputs.resource_group_name
  location                = dependency.bootstrap.outputs.location
  storage_account_name    = dependency.bootstrap.outputs.storage_account_name
  storage_container_name  = dependency.bootstrap.outputs.storage_container_name
  synapse_workspace_name  = "synapse-${local.env}-${local.project}"
  sql_administrator_login = "sqladminuser"
  sql_administrator_login_password = "ChangeMe123!" # Consider using a secret management solution
}

terraform {
  source = "../../../modules/synapse"
}