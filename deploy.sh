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
#TODO: this next line will only work on macOS
DEPLOYMENT_ID=$(echo $RANDOM | md5 | cut -c1-5)  # e.g., a1b2c
LOCATION="polandcentral"
RESOURCE_GROUP_NAME="rg-demo-automated-${DEPLOYMENT_ID}"
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
az synapse workspace wait --workspace-name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --created

# Assign Storage Blob Data Contributor role to Synapse workspace
log "INFO" "Assigning Storage Blob Data Contributor role to Synapse workspace..."
SYNAPSE_MANAGED_IDENTITY=$(az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --query identity.principalId -o tsv)
STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --query id -o tsv)
az role assignment create --assignee-object-id $SYNAPSE_MANAGED_IDENTITY --assignee-principal-type ServicePrincipal --role "Storage Blob Data Contributor" --scope $STORAGE_ACCOUNT_ID

# Enable Azure services access to the storage account
log "INFO" "Enabling Azure services access to the storage account..."
az storage account update --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --bypass AzureServices

# Add Synapse workspace IP to storage account firewall
log "INFO" "Adding Synapse workspace IP to storage account firewall..."
SYNAPSE_IP=$(az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --query connectivityEndpoints.sqlOnDemand -o tsv | awk -F: '{print $2}' | tr -d '/')
az storage account network-rule add --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --ip-address $SYNAPSE_IP

# Ensure the default action is to deny access
az storage account update --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --default-action Deny

# Get Workspace endpoints
log "INFO" "Retrieving Workspace endpoints..."
WorkspaceWeb=$(az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME | jq -r '.connectivityEndpoints | .web')
WorkspaceDev=$(az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME | jq -r '.connectivityEndpoints | .dev')

# Get Client IP
log "INFO" "Retrieving Client IP..."
ClientIP=$(curl -sb -H "Accept: application/json" "$WorkspaceDev" | jq -r '.message')
ClientIP=${ClientIP##'Client Ip address : '}

# Create firewall rule
log "INFO" "Creating firewall rule for IP: $ClientIP"
az synapse workspace firewall-rule create \
    --end-ip-address $ClientIP \
    --start-ip-address $ClientIP \
    --name "Allow Client IP" \
    --resource-group $RESOURCE_GROUP_NAME \
    --workspace-name $SYNAPSE_WORKSPACE_NAME

log "INFO" "Firewall rule created successfully"


# Deploy Dataset
# log "INFO" "Deploying Dataset..."
# az deployment group create \
#     --name DeployDataset \
#     --resource-group "$RESOURCE_GROUP_NAME" \
#     --template-file "${SCRIPT_DIR}/arm-templates/datasets/blob-dataset.json" \
#     --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME linkedServiceName=StorageLinkedService \
#     --output none

# log "INFO" "Dataset created in Synapse Workspace"

# Deploy Pipeline
# log "INFO" "Deploying Pipeline..."
# az deployment group create \
#     --name DeployPipeline \
#     --resource-group "$RESOURCE_GROUP_NAME" \
#     --template-file "${SCRIPT_DIR}/arm-templates/pipelines/copy-data-pipeline.json" \
#     --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME sourceDatasetName=BlobDataset sinkDatasetName=BlobDataset \
#     --output none

# log "INFO" "Pipeline created in Synapse Workspace"

# Deploy Trigger
# log "INFO" "Deploying Trigger..."
# az deployment group create \
#     --name DeployTrigger \
#     --resource-group "$RESOURCE_GROUP_NAME" \
#     --template-file "${SCRIPT_DIR}/arm-templates/triggers/blob-created-trigger.json" \
#     --parameters workspaceName=$SYNAPSE_WORKSPACE_NAME pipelineName=CopyDataPipeline storageAccountName=$STORAGE_ACCOUNT_NAME containerName=$CONTAINER_NAME \
#     --output none

# log "INFO" "Blob Created Trigger deployed in Synapse Workspace"

# Save deployment info for teardown
echo "$DEPLOYMENT_ID,$STORAGE_ACCOUNT_NAME,$CONTAINER_NAME,$SYNAPSE_WORKSPACE_NAME" >> "${SCRIPT_DIR}/deployments.log"

log "INFO" "Deployment completed successfully. Deployment ID: $DEPLOYMENT_ID"
log "INFO" "Storage Account: $STORAGE_ACCOUNT_NAME"
log "INFO" "Container: $CONTAINER_NAME"
log "INFO" "Synapse Workspace: $SYNAPSE_WORKSPACE_NAME"