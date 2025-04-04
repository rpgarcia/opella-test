terraform {
  backend "azurerm" {
    resource_group_name  = "example-resources"
    storage_account_name = "xxxxxxxx"
    container_name       = "tfstate"
    key                  = "dev/web_public/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.25.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "bootstrap_state" {
  backend = "azurerm"
  config = {
    resource_group_name  = "example-resources"
    storage_account_name = "xxxxxxxx"
    container_name       = "tfstate"
    key                  = "dev/bootstrap/terraform.tfstate"
  }
}
