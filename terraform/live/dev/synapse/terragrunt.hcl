
include {
  path = find_in_parent_folders()
}

dependency "resource_group" {
  config_path = "../resource_group"
}

terraform {
  source = "../../../modules/synapse"
}

inputs = {
  name                = "synapse-${get_env("TF_VAR_ENV", "dev")}"
  resource_group_name = dependency.resource_group.outputs.name
  location            = dependency.resource_group.outputs.location
}