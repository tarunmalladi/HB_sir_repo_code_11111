terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.89.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.32.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "terraform-rg"
    storage_account_name  = "orxaimterraformsa"
    container_name        = "tfstate"
    key                   = "orxaimsa.tfstate"
  }
}


provider "azurerm" {
  client_id         = var.client_id
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id
  features {}
}
