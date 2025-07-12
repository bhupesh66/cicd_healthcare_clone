terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate147025af"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"  # Name of the state file in blob storage
  }
}
