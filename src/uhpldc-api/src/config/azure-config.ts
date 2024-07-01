import { DefaultAzureCredential } from "@azure/identity";
import { SynapseManagementClient } from "@azure/arm-synapse";

export const credential = new DefaultAzureCredential();
export const subscriptionId = process.env.AZURE_SUBSCRIPTION_ID || '';
export const resourceGroup = process.env.AZURE_RESOURCE_GROUP || '';
export const workspaceName = process.env.SYNAPSE_WORKSPACE_NAME || '';

export const synapseClient = new SynapseManagementClient(credential, subscriptionId);