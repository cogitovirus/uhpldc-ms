include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/bootstrap"
}

inputs = {
  resource_group_name  = "tfstate"
  location             = "East US"
  storage_account_name = "tfstatedev"
  container_name       = "tfstate"
}