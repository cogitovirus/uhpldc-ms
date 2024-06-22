resource "azurerm_synapse_workspace" "synapse" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password
}

variable "name" {
  description = "The name of the Synapse workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the Synapse workspace"
  type        = string
}

variable "storage_data_lake_gen2_filesystem_id" {
  description = "The ID of the storage data lake Gen2 filesystem"
  type        = string
}

variable "sql_administrator_login" {
  description = "The SQL administrator login for the Synapse workspace"
  type        = string
}

variable "sql_administrator_login_password" {
  description = "The SQL administrator login password for the Synapse workspace"
  type        = string
  sensitive   = true
}

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.synapse.id
}

output "synapse_workspace_name" {
  value = azurerm_synapse_workspace.synapse.name
}
