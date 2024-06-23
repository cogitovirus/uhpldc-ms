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

Ensure you are authenticated to Azure CLI before running the commands. You can authenticate using Azure Active Directory (Azure AD) or provide storage account credentials.

1. **Authenticate using Azure AD**:

    ```sh
    az login
    ```

2. **run the bootstrap scripts**

    ```sh
    cd terraform/live/dev/bootstrap
    terragrunt init
    terragrunt apply
    ```

3. Create the rest of the infrastructure

## Teardown of dev/prod

```sh
# Navigate to the dev environment directory
cd terragrunt/envs/dev

# Destroy all resources in the dev environment
terragrunt destroy-all
```

## Additional Information

For more detailed instructions and information, refer to the documentation provided in the repository.
