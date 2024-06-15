# terragrunt-project/live/dev/terragrunt.hcl

include {
  path = find_in_parent_folders()
}

inputs = {
  resource_group_name = "uhpldc-ms"
  location            = "eastus"
}
