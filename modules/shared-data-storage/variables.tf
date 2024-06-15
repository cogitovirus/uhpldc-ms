# terragrunt-project/modules/shared-storage-account/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "uhpldcms"
}

variable "location" {
  description = "The Azure region to deploy to"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "uhpldcms-storage-account"
}
