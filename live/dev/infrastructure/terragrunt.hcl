terraform {
  source = "../../../modules/resource-group"
}

inputs = {
  name     = "dev-resource-group"
  location = "eastus"
}

include {
  path = find_in_parent_folders()
}
