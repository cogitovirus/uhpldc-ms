#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

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

# Error handling function
handle_error() {
    log "ERROR" "An error occurred on line $1"
    log "ERROR" "Deployment failed. Please check the error messages above."
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Set variables
LOCATION="polandcentral"
RESOURCE_GROUP_NAME="rg-demo-automated${DEPLOYMENT_ID}"
DEPLOYMENT_ID=$(date +%Y%m%d%H%M)  # Use timestamp for unique identifier, removed seconds for shorter name
STORAGE_ACCOUNT_NAME="synstore${DEPLOYMENT_ID}"  # Shortened name to fit 24 character limit
CONTAINER_NAME="syncontainer"
SYNAPSE_WORKSPACE_NAME="synws${DEPLOYMENT_ID}"

# Check if SQL_ADMIN_PASSWORD is provided as a script argument
if [ $# -eq 0 ]; then
    log "ERROR" "SQL_ADMIN_PASSWORD is not provided. Usage: $0 <SQL_ADMIN_PASSWORD>"
    exit 1
fi

SQL_ADMIN_PASSWORD=$1

log "INFO" "Starting deployment with ID: $DEPLOYMENT_ID"

log "INFO" "Creating Resource Group..."
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" --output none

log "INFO" "Resource Group $RESOURCE_GROUP_NAME created in $LOCATION"

# Deploy Storage Account
log "INFO" "Deploying Storage Account..."
az deployment group create \
    --name DeployStorageAccount \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/arm-templates/storage/storage.json" \
    --parameters storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME location=$LOCATION \
    --output none

log "INFO" "Storage account $STORAGE_ACCOUNT_NAME created with container $CONTAINER_NAME"

# Deploy Synapse Workspace
log "INFO" "Deploying Synapse Workspace..."
az deployment group create \
    --name DeploySynapseWorkspace \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/arm-templates/synapse/azuredeploy.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME \
                 location=$LOCATION \
                 sqlAdministratorLogin=sqladminuser \
                 sqlAdministratorLoginPassword="$SQL_ADMIN_PASSWORD" \
                 storageAccountName=$STORAGE_ACCOUNT_NAME \
                 fileSystemName=$CONTAINER_NAME \
    --output none

log "INFO" "Synapse Workspace $SYNAPSE_WORKSPACE_NAME created"

# Wait for Synapse Workspace to be fully provisioned
log "INFO" "Waiting for Synapse Workspace to be fully provisioned..."
az synapse workspace wait --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --created

# Deploy Linked Service
log "INFO" "Deploying Linked Service..."
az deployment group create \
    --name DeployLinkedService \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}arm-templates/linked-services/storage-linked-service.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME storageAccountName=$STORAGE_ACCOUNT_NAME \
    --output none

log "INFO" "Linked Service created for Storage Account $STORAGE_ACCOUNT_NAME"

# Deploy Dataset
log "INFO" "Deploying Dataset..."
az deployment group create \
    --name DeployDataset \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/arm-templates/datasets/blob-dataset.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME linkedServiceName=StorageLinkedService \
    --output none

log "INFO" "Dataset created in Synapse Workspace"

# Deploy Pipeline
log "INFO" "Deploying Pipeline..."
az deployment group create \
    --name DeployPipeline \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/arm-templates/pipelines/copy-data-pipeline.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME sourceDatasetName=BlobDataset sinkDatasetName=BlobDataset \
    --output none

log "INFO" "Pipeline created in Synapse Workspace"

# Deploy Trigger
log "INFO" "Deploying Trigger..."
az deployment group create \
    --name DeployTrigger \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "${SCRIPT_DIR}/arm-templates/triggers/blob-created-trigger.json" \
    --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME pipelineName=CopyDataPipeline storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME \
    --output none

log "INFO" "Blob Created Trigger deployed in Synapse Workspace"

# Save deployment info for teardown
echo "$DEPLOYMENT_ID,$STORAGE_ACCOUNT_NAME,$CONTAINER_NAME,$SYNAPSE_WORKSPACE_NAME" >> "${SCRIPT_DIR}/deployments.log"

log "INFO" "Deployment completed successfully. Deployment ID: $DEPLOYMENT_ID"
log "INFO" "Storage Account: $STORAGE_ACCOUNT_NAME"
log "INFO" "Container: $CONTAINER_NAME"
log "INFO" "Synapse Workspace: $SYNAPSE_WORKSPACE_NAME"