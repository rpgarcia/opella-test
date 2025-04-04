#!/bin/bash

# config
RESOURCE_GROUP="example-resources"
STORAGE_ACCOUNT_NAME="xxxxxxx"

echo "> Getting user info"
echo "Resource Group: $RESOURCE_GROUP"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
USER_ID=$(az ad signed-in-user show --query id -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "- User: $USER_ID"
echo "- Subscriptin ID:: $SUBSCRIPTION_ID"

echo "> Assign role 'Storage Blob Data Contributor' to Storage Account"

az role assignment create \
  --assignee "$USER_ID" \
  --role "Storage Blob Data Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME"

echo "Role assigned."