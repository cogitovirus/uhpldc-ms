# terragrunt-project/live/dev/infrastructure/terragrunt.hcl

terraform {
  source = "../../../modules/shared-data-storage"
}

inputs = {
  name     = "uhpldc-ms"
  location = "eastus"
}

include {
  path = find_in_parent_folders()
}
