# terragrunt-project/modules/resource-group/variables.tf

variable "name" {
  description = "The name of the resource group"
  type        = string
  default = "uhpldcms"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "eastus"
}
