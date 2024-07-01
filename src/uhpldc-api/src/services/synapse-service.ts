import { synapseClient, resourceGroup, workspaceName } from '../config/azure-config';

export async function getWorkspaces() {
  return synapseClient.workspaces.get(resourceGroup, workspaceName);
}

export async function listSqlPools() {
  return synapseClient.sqlPools.listByWorkspace(resourceGroup, workspaceName);
}

// Add more functions as needed