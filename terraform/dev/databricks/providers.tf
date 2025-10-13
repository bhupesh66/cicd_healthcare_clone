terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.34.0"
    }
  }

  required_version = ">= 1.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id


}

provider "databricks" {
  azure_workspace_resource_id = var.azure_databricks_workspace_resource_id

  azure_client_id     = var.azure_client_id
  azure_client_secret = var.azure_client_secret
  azure_tenant_id     = var.azure_tenant_id
}
