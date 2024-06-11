# uhpldc-ms
Ultra-High Performance Liquid Data Chromatography with Mass Spectrometry

## Introduction

Azure + Terragrunt + Synapse + LLMs + Blockchain = uhpldc-ms

## Prerequisites

Before you begin, ensure you have the following installed:
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

## Installation

Follow these steps to set up and deploy the infrastructure:

1. **Create Azure Resources**:
    ```sh
    az group create --name uhpldc-ms --location eastus
    az storage account create --name uhpldcmsstorage --resource-group uhpldc-ms --location eastus --sku Standard_LRS
    az storage container create --name tfstate --account-name uhpldcmsstorage
    ```

2. **Configure Backend in Terraform**:

    Ensure that your `main.tf` includes the Azure backend configuration. Here is an example for the `resource-group` module:

    ```hcl
    terraform {
      backend "azurerm" {
        resource_group_name  = "uhpldc-ms"
        storage_account_name = "uhpldcmsstorage"
        container_name       = "tfstate"
        key                  = "resource-group/terraform.tfstate"
      }
    }
    ```

3. **Configure Global Terragrunt Settings**:

    In the root of your project, create a `terragrunt.hcl` file with the following content:

    ```hcl
    remote_state {
      backend = "azurerm"

      config = {
        resource_group_name  = "uhpldc-ms"
        storage_account_name = "uhpldcmsstorage"
        container_name       = "tfstate"
        key                  = "${path_relative_to_include()}/terraform.tfstate"
      }
    }
    ```

4. **Initialize and Apply Terragrunt**:

    Navigate to your project directory and run the following commands:

    ```sh
    # Navigate to the resource group setup
    cd terragrunt-project/live/dev/infrastructure

    # Initialize Terragrunt
    terragrunt init

    # Apply the configuration to create the resource group
    terragrunt apply

    # Navigate to the VM setup
    cd vm

    # Initialize Terragrunt
    terragrunt init

    # Apply the configuration to create the VM
    terragrunt apply
    ```

This will provision the necessary resources in Azure using the configurations defined in your Terragrunt and Terraform files.

## Additional Information

For more detailed instructions and information, refer to the documentation provided in the repository.
