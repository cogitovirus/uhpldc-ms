# /Users/wiktor/Projects/uhpldc-ms/terraform/modules/synapse/outputs.tf

output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.this.id
}

output "synapse_workspace_name" {
  value = azurerm_synapse_workspace.this.name
}