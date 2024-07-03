#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message"
}

# Set variables
LOCATION="polandcentral"
RESOURCE_GROUP_NAME="uhpldc-ms-demo-wz"
STORAGE_ACCOUNT_NAME="synapsestorage$RANDOM"  # Ensure uniqueness
CONTAINER_NAME="synapsecontainer"

# Deploy Resource Group
# az deployment sub create \
#     --name DeployResourceGroup \
#     --location "$LOCATION" \
#     --template-file "${SCRIPT_DIR}/../arm-templates/resource-group/azuredeploy.json" \
#     --parameters @"${SCRIPT_DIR}/../arm-templates/resource-group/parameters.json"

# # Deploy Synapse Workspace
# az deployment group create \
#     --name DeploySynapseWorkspace \
#     --resource-group "$RESOURCE_GROUP_NAME" \
#     --template-file "${SCRIPT_DIR}/../arm-templates/synapse/azuredeploy.json" \
#     --parameters @"${SCRIPT_DIR}/../arm-templates/synapse/parameters.json"

# Deploy Storage Account
az deployment group create \
    --name DeployStorageAccount \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/storage/storage.json" \
    --parameters storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME location=$LOCATION

log "INFO" "Storage account $STORAGE_ACCOUNT_NAME created with container $CONTAINER_NAME"
