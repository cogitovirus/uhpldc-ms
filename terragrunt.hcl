# Define the backend configuration for remote state storage
remote_state {
  backend = "azurerm"

  config = {
    resource_group_name  = "my-terraform-state"
    storage_account_name = "mystorageaccount"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Optionally, include any other common configurations or settings
