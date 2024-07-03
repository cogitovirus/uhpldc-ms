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
RESOURCE_GROUP_NAME="uhpldc-ms-demo-wz"

# Read deployments from log file
DEPLOYMENTS_FILE="${SCRIPT_DIR}/deployments.log"

if [ ! -f "$DEPLOYMENTS_FILE" ]; then
    log "ERROR" "Deployments log file not found: $DEPLOYMENTS_FILE"
    exit 1
fi

while IFS=',' read -r DEPLOYMENT_ID STORAGE_ACCOUNT_NAME CONTAINER_NAME SYNAPSE_WORKSPACE_NAME
do
    log "INFO" "Processing teardown for Deployment ID: $DEPLOYMENT_ID"

    # Delete Synapse Workspace
    if az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME &>/dev/null; then
        log "INFO" "Deleting Synapse workspace: $SYNAPSE_WORKSPACE_NAME"
        az synapse workspace delete --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --yes
        if [ $? -eq 0 ]; then
            log "INFO" "Successfully deleted Synapse workspace: $SYNAPSE_WORKSPACE_NAME"
        else
            log "ERROR" "Failed to delete Synapse workspace: $SYNAPSE_WORKSPACE_NAME"
        fi
    else
        log "INFO" "Synapse workspace not found: $SYNAPSE_WORKSPACE_NAME. Skipping deletion."
    fi

    # Delete Storage Account
    if az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME &>/dev/null; then
        log "INFO" "Deleting storage account: $STORAGE_ACCOUNT_NAME"
        az storage account delete --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --yes
        if [ $? -eq 0 ]; then
            log "INFO" "Successfully deleted storage account: $STORAGE_ACCOUNT_NAME"
        else
            log "ERROR" "Failed to delete storage account: $STORAGE_ACCOUNT_NAME"
        fi
    else
        log "INFO" "Storage account not found: $STORAGE_ACCOUNT_NAME. Skipping deletion."
    fi

    log "INFO" "Completed teardown for Deployment ID: $DEPLOYMENT_ID"

done < "$DEPLOYMENTS_FILE"

# Clear the deployments log file
> "$DEPLOYMENTS_FILE"

log "INFO" "All resource deletions completed."

# Uncomment the following lines if you want to delete the entire resource group
# log "INFO" "Deleting resource group: $RESOURCE_GROUP_NAME"
# az group delete --name $RESOURCE_GROUP_NAME --yes
# if [ $? -eq 0 ]; then
#     log "INFO" "Successfully deleted resource group: $RESOURCE_GROUP_NAME"
# else
#     log "ERROR" "Failed to delete resource group: $RESOURCE_GROUP_NAME"
# fi