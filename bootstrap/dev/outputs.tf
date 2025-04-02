output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.tfstate.id
}

output "storage_container_name" {
  description = "Name of the blob container used for state"
  value       = azurerm_storage_container.tfstate.name
}

output "default_tags" {
    value = local.default_tags
}

output "organization" {
    value = local.settings.organization
}

output "region" {
    value = local.settings.region
}

output "account" {
    value = local.settings.account
}

output "environment" {
    value = local.settings.environment
}

# output "storage_account_primary_access_key" {
#   description = "Primary access key of the storage account (sensitive)"
#   value       = azurerm_storage_account.tfstate.primary_access_key
#   sensitive   = true
# }