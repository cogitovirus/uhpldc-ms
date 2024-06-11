terraform {
  source = "../../../../modules//vm"
}

inputs = {
  vnet_name           = "dev-vnet"
  subnet_name         = "dev-subnet"
  nic_name            = "dev-nic"
  vm_name             = "dev-vm"
  location            = "eastus"
  resource_group_name = "dev-resource-group"
  admin_username      = "azureuser"
  admin_password      = "Password123!"
}

include {
  path = find_in_parent_folders()
}
