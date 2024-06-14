# terragrunt-project/modules/synapse/outputs.tf

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.synapse_workspace.id
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}
