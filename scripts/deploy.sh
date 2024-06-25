#!/bin/bash

# Set variables
LOCATION="Poland Central"
RESOURCE_GROUP_NAME="rg-synapse-dev-polandcentral"

# Deploy Resource Group
az deployment sub create \
    --name DeployResourceGroup \
    --location "$LOCATION" \
    --template-file ../arm-templates/resource-group/azuredeploy.json \
    --parameters @../arm-templates/resource-group/parameters.json

# Deploy Synapse Workspace
az deployment group create \
    --name DeploySynapseWorkspace \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file ../arm-templates/synapse/azuredeploy.json \
    --parameters @../arm-templates/synapse/parameters.json