variable "name" {
  type        = string
  description = "Name of the Azure Synapse workspace"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "environment" {
  type        = string
  description = "Environment name (used in storage account name)"
}