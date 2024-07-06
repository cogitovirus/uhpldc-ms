#!/bin/bash

# Load variables from deployment
source deployment_vars.sh

RESOURCE_GROUP_NAME="rg-demo-automated"

# Delete resource group (this will delete all resources within it)
echo "Deleting resource group..."
az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait

echo "Teardown initiated. Resource group and all its resources will be deleted."