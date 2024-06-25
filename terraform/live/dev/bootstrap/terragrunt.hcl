locals {
  env     = lower(get_env("TF_ENV", "dev"))
  project = lower(get_env("TF_PROJECT", ""))
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  random_suffix = substr(md5(local.timestamp), 0, 6)
}

include {
  path = find_in_parent_folders()
}

inputs = {
  resource_group_name  = "tfstate-${local.env}-${local.project}-rg"
  location             = "Poland Central"
  storage_account_name = "tf${local.env}${local.project}${local.random_suffix}"
  container_name       = "tfstate"
}

terraform {
  source = "../../../modules/bootstrap"
}