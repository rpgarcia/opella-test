resource "azurerm_resource_group" "site" {
  name     = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "static" {
  name                     = "staticweb${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.site.name
  location                 = azurerm_resource_group.site.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "static" {
  storage_account_id = azurerm_storage_account.static.id
  error_404_document = "404.html"
  index_document     = "index.html"
}