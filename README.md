# uhpldc-ms

Ultra-High Performance Liquid Data Chromatography with Mass Spectrometry

## Introduction

Azure + Terragrunt + Synapse + LLMs + Blockchain = uhpldc-ms

For more details see the [Whitepaper](docs/whitepaper_to_be_pdf.md)
or [faq](docs/faq.md).

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

2. **Initialize and Apply Terragrunt**:

    Navigate to the project root directory and run the following commands:

    ```sh
    # Navigate to the project root
    cd uhpldc-ms

    # Initialize Terragrunt for all configurations
    terragrunt run-all init

    # Apply the configuration to create the resource group and VM
    terragrunt run-all apply
    ```

This will provision the necessary resources in Azure using the configurations defined in your Terragrunt and Terraform files.

## Teardown of dev/prod

```sh
# Navigate to the dev environment directory
cd terragrunt-project/live/dev

# Destroy all resources in the dev environment
terragrunt destroy-all
```

## Additional Information

For more detailed instructions and information, refer to the documentation provided in the repository.
