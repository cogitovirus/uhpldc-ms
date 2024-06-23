include {
  path = find_in_parent_folders()
}

inputs = {
  resource_group_name  = "tfstate"
  location             = "Poland Central"
  storage_account_name = "tfstatedev"
  container_name       = "tfstate"
}

terraform {
  source = "../../../modules/bootstrap"
}
