terraform {
  source = "../../../modules/bootstrap"
}

inputs = {
  resource_group_name   = "uhpldc-ms-rg"
  location              = "East US"
  storage_account_name  = "uhpldcmsstorage"
  container_name        = "tfstate"
}
