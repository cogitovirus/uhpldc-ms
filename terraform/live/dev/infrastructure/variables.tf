variable "name" {
  description = "The name of the resource group"
  type        = string
  default     = "uhpldc-ms"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "uhpldcmsstorage"
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = "tfstate"
}

variable "key" {
  description = "The key for the state file"
  type        = string
  default     = "infrastructure/terraform.tfstate"
}
