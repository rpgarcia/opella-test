output "resource_group_name" {
  value = azurerm_resource_group.site.name
}

output "storage_account_name" {
  value = azurerm_storage_account.static.name
}

output "primary_web_host" {
  value = azurerm_storage_account.static.primary_web_host
}