
include {
  path = find_in_parent_folders()
}

dependency "bootstrap" {
  config_path = "../bootstrap"
}

terraform {
  source = "../../../modules/synapse"
}

inputs = {
  name                = "synapse0${get_env("TF_ENV", "dev")}"
  resource_group_name = dependency.resource_group.outputs.name
  location            = dependency.resource_group.outputs.location
}