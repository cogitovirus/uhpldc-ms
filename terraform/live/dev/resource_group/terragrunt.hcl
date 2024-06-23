include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/resource_group"
}

inputs = {
  name     = "rg-synapse-${get_env("TF_VAR_ENV", "dev")}"
  location = "East US"
}