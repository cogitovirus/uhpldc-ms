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

4. **Ensure Unique Variable Declarations**:

    Check your `main.tf` and `variables.tf` files within each module to ensure that variables are declared only once.

    Example `variables.tf` for the `resource-group` module:

    ```hcl
    variable "name" {
      description = "The name of the resource group"
      type        = string
    }

    variable "location" {
      description = "The location of the resource group"
      type        = string
      default     = "eastus"
    }
    ```

5. **Initialize and Apply Terragrunt**:

    Navigate to your project directory and run the following commands:

    ```sh
    # Navigate to the project root
    cd terragrunt-project

    # Initialize Terragrunt for all configurations
    terragrunt init-all

    # Apply the configuration to create the resource group and VM
    terragrunt apply-all
    ```

This will provision the necessary resources in Azure using the configurations defined in your Terragrunt and Terraform files.

## Additional Information

For more detailed instructions and information, refer to the documentation provided in the repository.
