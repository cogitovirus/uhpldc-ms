module "resource_group" {
  source  = "../../modules/resource_group"
  name    = "uhpldc-ms"
  location = "Poland Central"
}

module "storage_account" {
  source              = "../../modules/storage_account"
  name                = "devstorageacct"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
}

module "synapse" {
  source                             = "../../modules/synapse"
  name                               = "devsynapseworkspace"
  resource_group_name                = module.resource_group.resource_group_name
  location                           = module.resource_group.location
  storage_data_lake_gen2_filesystem_id = module.storage_account.storage_account_id
  sql_administrator_login            = "adminuser"
  sql_administrator_login_password   = var.synapse_sql_password
}

variable "synapse_sql_password" {
  description = "The password for the Synapse SQL administrator"
  type        = string
  sensitive   = true
}
