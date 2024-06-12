# terragrunt-project/live/dev/infrastructure/variables.tf

variable "name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}
