terraform {
  extra_arguments "init_args" {
    commands = [
      "init"
    ]
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.109.0"
    }
  }
}

provider "azurerm" {
  features {}
}
EOF
}