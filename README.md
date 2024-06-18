<!-- markdownlint-disable-next-line MD041 -->
![uhpldc-ms](docs/spectreseek_promo.png)

**U**ltra-**H**igh **P**erformance **L**iquid **D**ata **C**hromatography --with-- **M**ass **S**pectrometry

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

1. **Bootstrap Resource Group and Storage Account**

    ```sh
    # Navigate to the bootstrap directory
    cd terraform/bootstrap

    # Initialize Terraform
    terragrunt init

    # Apply the configuration to create the resource group and storage account
    terragrunt apply
    ```

2. **Initialize and Apply Terragrunt for Main Infrastructure**

    Navigate to the project terraform directory and run the following commands:

    ```sh
    # Navigate to the project terraform directory
    cd ..

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
