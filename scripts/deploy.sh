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
DEPLOYMENT_ID=$(date +%Y%m%d%H%M%S)  # Use timestamp for unique identifier
STORAGE_ACCOUNT_NAME="synapsestorage${DEPLOYMENT_ID}"
CONTAINER_NAME="synapsecontainer"
SYNAPSE_WORKSPACE_NAME="synapsews${DEPLOYMENT_ID}"

log "INFO" "Starting deployment with ID: $DEPLOYMENT_ID"

# Deploy Resource Group (uncomment if needed)
# az deployment sub create \
#     --name DeployResourceGroup \
#     --location "$LOCATION" \
#     --template-file "${SCRIPT_DIR}/../arm-templates/resource-group/azuredeploy.json" \
#     --parameters @"${SCRIPT_DIR}/../arm-templates/resource-group/parameters.json"

# Deploy Storage Account
az deployment group create \
    --name DeployStorageAccount \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/storage/storage.json" \
    --parameters storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME location=$LOCATION

log "INFO" "Storage account $STORAGE_ACCOUNT_NAME created with container $CONTAINER_NAME"

# Deploy Synapse Workspace
az deployment group create \
    --name DeploySynapseWorkspace \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/synapse/azuredeploy.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME location=$LOCATION storageAccountName=$STORAGE_ACCOUNT_NAME fileSystemName=$CONTAINER_NAME

log "INFO" "Synapse Workspace $SYNAPSE_WORKSPACE_NAME created"

# Deploy Linked Service
az deployment group create \
    --name DeployLinkedService \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/linked-services/storage-linked-service.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME storageAccountName=$STORAGE_ACCOUNT_NAME

log "INFO" "Linked Service created for Storage Account $STORAGE_ACCOUNT_NAME"

# Deploy Dataset
az deployment group create \
    --name DeployDataset \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/datasets/blob-dataset.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME linkedServiceName=StorageLinkedService

log "INFO" "Dataset created in Synapse Workspace"

# Deploy Pipeline
az deployment group create \
    --name DeployPipeline \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/pipelines/copy-data-pipeline.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME sourceDatasetName=BlobDataset sinkDatasetName=BlobDataset

log "INFO" "Pipeline created in Synapse Workspace"

# Deploy Trigger
az deployment group create \
    --name DeployTrigger \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/../arm-templates/triggers/blob-created-trigger.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME pipelineName=CopyDataPipeline storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME

log "INFO" "Blob Created Trigger deployed in Synapse Workspace"

# Save deployment info for teardown
echo "$DEPLOYMENT_ID,$STORAGE_ACCOUNT_NAME,$CONTAINER_NAME,$SYNAPSE_WORKSPACE_NAME" >> "${SCRIPT_DIR}/deployments.log"

log "INFO" "Deployment completed successfully. Deployment ID: $DEPLOYMENT_ID"
log "INFO" "Storage Account: $STORAGE_ACCOUNT_NAME"
log "INFO" "Container: $CONTAINER_NAME"
log "INFO" "Synapse Workspace: $SYNAPSE_WORKSPACE_NAME"