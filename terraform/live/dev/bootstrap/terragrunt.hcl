locals {
  env     = get_env("TF_ENV", "dev")  # Use TF_ENV if set, default to "dev" if not
  project = get_env("TF_PROJECT", "")  # Use TF_PROJECT if set, default to empty string if not
}

include {
  path = find_in_parent_folders()
}

inputs = {
  resource_group_name  = "tfstate-${local.env}-${local.project}-rg"
  location             = "Poland Central"
  storage_account_name = "tfstate${local.env}${local.project}sa"
  container_name       = "tfstate"
}

terraform {
  source = "../../../modules/bootstrap"
}