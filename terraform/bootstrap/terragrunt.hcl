terraform {
  source = "./"
}

inputs = {
  resource_group_name  = "uhpldc-ms"
  location             = "eastus"
  storage_account_name = "uhpldcmsstorage"
  container_name       = "tfstate"
}
