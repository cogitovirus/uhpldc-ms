# terragrunt-project/modules/synapse/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy to"
  type        = string
  default     = "eastus"
}

variable "synapse_workspace_name" {
  description = "The name of the Synapse workspace"
  type        = string
  default     = "uhpldcms-synapse-workspace"
}

variable "sql_administrator_login" {
  description = "The SQL administrator login"
  type        = string
  default     = "adminuser"
}

variable "sql_administrator_login_password" {
  description = "The SQL administrator login password"
  type        = string
  sensitive   = true
  default     = "P@ssword1234" #TODO: exposed password
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "uhpldcms-synapse-storage-acct"
}
