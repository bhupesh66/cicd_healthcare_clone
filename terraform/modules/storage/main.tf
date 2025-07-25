resource "random_id" "suffix" {
  byte_length = 4
}


resource "azurerm_storage_account" "storage" {
  name                     = "${substr(var.storage_account_name, 0, 12)}${random_id.suffix.hex}"

  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Send diagnostics to Log Analytics


output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}
