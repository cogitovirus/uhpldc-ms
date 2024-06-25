#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set variables
LOCATION="Poland Central"
RESOURCE_GROUP_NAME="rg-synapse-dev-polandcentral"

# Deploy Resource Group
az deployment sub create \
    --name DeployResourceGroup \
    --location "$LOCATION" \
    --template-file "${SCRIPT_DIR}/../arm-templates/resource-group/azuredeploy.json" \
    --parameters @"${SCRIPT_DIR}/../arm-templates/resource-group/parameters.json"

# Deploy Synapse Workspace
az deployment group create \
    --name DeploySynapseWorkspace \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/synapse/azuredeploy.json" \
    --parameters @"${SCRIPT_DIR}/../arm-templates/synapse/parameters.json"