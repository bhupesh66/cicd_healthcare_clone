terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3"
}


provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = jsondecode(var.azure_credentials).subscriptionId
  client_id       = jsondecode(var.azure_credentials).clientId
  client_secret   = jsondecode(var.azure_credentials).clientSecret
  tenant_id       = jsondecode(var.azure_credentials).tenantId


}