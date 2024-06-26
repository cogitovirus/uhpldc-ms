#!/bin/bash

# Set variables
RESOURCE_GROUP_NAME="rg-synapse-dev-polandcentral"
SYNAPSE_WORKSPACE_NAME="synapse-workspace-dev-polandcentral"

# Check if the Synapse workspace exists and delete it
if az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME &>/dev/null; then
    echo "Deleting Synapse workspace..."
    az synapse workspace delete --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --yes
else
    echo "Synapse workspace not found. Skipping deletion."
fi

# Delete the resource group
echo "Deleting resource group..."
az group delete --name $RESOURCE_GROUP_NAME --yes

echo "Resource deletion completed."