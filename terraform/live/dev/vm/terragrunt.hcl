terraform {
  source = "../../../modules/vm//"
  
  backend "azurerm" {
    resource_group_name   = "uhpldc-ms"
    storage_account_name  = "uhpldcmsstorage"
    container_name        = "tfstate"
    key                   = "vm/terraform.tfstate"
  }
}

inputs = {
  container_name                       = "tfstate"
  storage_account_name                 = "uhpldcmsstorage"
  key                                  = "vm/terraform.tfstate"
  vnet_name           = "dev-vnet"
  subnet_name         = "dev-subnet"
  nic_name            = "dev-nic"
  vm_name             = "dev-vm"
  location            = "eastus"
  resource_group_name = "uhpldc-ms"
  admin_username      = "azureuser"
  admin_password      = "Password123!"
  vm_size             = "Standard_B1ls"
  os_image            = "Canonical:UbuntuServer:18.04-LTS:latest"
}

include {
  path = find_in_parent_folders()
}
