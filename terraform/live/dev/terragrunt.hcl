inputs = {
  resource_group_name = "uhpldc-ms"
  location            = "eastus"
}

include {
  path = find_in_parent_folders()
}
