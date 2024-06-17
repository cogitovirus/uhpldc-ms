terraform {
  source = "../../../modules/shared-data-storage//"
}

inputs = {
  name                 = "uhpldc-ms"
  location             = "eastus"
  container_name       = "tfstate"
  storage_account_name = "uhpldcmsstorage"
  key                  = "infrastructure/terraform.tfstate"
}

include {
  path = "../../terragrunt.hcl"
}
