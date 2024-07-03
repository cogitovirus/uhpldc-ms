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
SYNAPSE_WORKSPACE_NAME="synapse-workspace-dev-polandcentral"
STORAGE_ACCOUNT_PREFIX="synapsestorage"

# Check if the Synapse workspace exists and delete it
# if az synapse workspace show --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME &>/dev/null; then
#     echo "Deleting Synapse workspace..."
#     az synapse workspace delete --name $SYNAPSE_WORKSPACE_NAME --resource-group $RESOURCE_GROUP_NAME --yes
# else
#     echo "Synapse workspace not found. Skipping deletion."
# fi

# Delete the resource group
# echo "Deleting resource group..."
# az group delete --name $RESOURCE_GROUP_NAME --yes

# Find and delete storage accounts
log "INFO" "Searching for storage accounts with prefix '$STORAGE_ACCOUNT_PREFIX' in resource group '$RESOURCE_GROUP_NAME'"

storage_accounts=$(az storage account list --resource-group $RESOURCE_GROUP_NAME --query "[?starts_with(name, '$STORAGE_ACCOUNT_PREFIX')].name" -o tsv)

if [ -z "$storage_accounts" ]; then
    log "INFO" "No storage accounts found with the specified prefix."
else
    for account in $storage_accounts; do
        log "INFO" "Deleting storage account: $account"
        az storage account delete --name $account --resource-group $RESOURCE_GROUP_NAME --yes
        if [ $? -eq 0 ]; then
            log "INFO" "Successfully deleted storage account: $account"
        else
            log "ERROR" "Failed to delete storage account: $account"
        fi
    done
fi

log "INFO" "Resource deletion completed."
