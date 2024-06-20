dependency "infrastructure" {
  config_path = "../infrastructure"

  mock_outputs = {
    resource_group_name  = "uhpldc-ms"
    storage_account_name = "uhpldcmsstorage"
    container_name       = "tfstate"
    location             = "eastus"
  }

  skip_outputs = false
}

dependency "bootstrap" {
  config_path = "../bootstrap//"
  mock_outputs = {
    resource_group_name = "uhpldc-ms"
  }
}

terraform {
  source = "../../../modules/vm//"
}

inputs = {
  resource_group_name                  = dependency.bootstrap.outputs.resource_group_name
  container_name                       = "tfstate"
  storage_account_name                 = "uhpldcmsstorage"
  key                                  = "vm/terraform.tfstate"
  vnet_name                            = "dev-vnet"
  subnet_name                          = "dev-subnet"
  nic_name                             = "dev-nic"
  vm_name                              = "dev-vm"
  location                             = "eastus"
  admin_username                       = "azureuser"
  admin_password                       = "Password123!"
  vm_size                              = "Standard_B1ls"
  os_image                             = "Canonical:UbuntuServer:18.04-LTS:latest"
}

include {
  path = "../../terragrunt.hcl"
}
