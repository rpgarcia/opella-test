locals {
    defaults       = file("./default_vars.yml")
    environment_path = "./default_vars.yml"
    environment_variables = fileexists(local.environment_path) ? file(local.environment_path) : yamlencode({})
    
    settings = merge(
        yamldecode(local.defaults),
        yamldecode(local.environment_variables)
    )

    organization_name = local.settings.organization
    project_name      = "${local.settings.account}-azure-${local.settings.environment}"
    
    default_tags = {
        "iac:tool"    = "terraform"
        "account"     = local.settings.account
        "environment" = local.settings.environment
        "terraformed" = "yes"
        "generated_by" = basename(abspath(path.module))
    }
}

terraform {
  backend "azurerm" {} # Comment for the first execution

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "example-resources"
  location = "East Us"
  tags = merge(local.default_tags, {})
}


resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.suffix.result}" # unique
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  # public_network_access_enabled = false
  allow_nested_items_to_be_public = false
  # allow_blob_public_access = true
  
  tags = merge(
    var.tags,
    {
      role = "terraform-backend"
      tier = "backend"
    }
  )
}

resource "azurerm_storage_account_network_rules" "tfstate_rules" {
  storage_account_id = azurerm_storage_account.tfstate.id

  default_action             = "Deny"
  ip_rules                   = ["127.0.0.1"]  # my ip
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id  = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}