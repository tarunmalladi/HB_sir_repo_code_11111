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
}


provider "azurerm" {
  client_id         = var.client_id
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id
  features {}
}
