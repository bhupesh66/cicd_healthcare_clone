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

# Create multiple containers dynamically
resource "azurerm_storage_container" "containers" {
  for_each = toset(var.container_names) # Now supports multiple containers
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}




# Outputs for reuse
output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "containers" {
  value = { for name, container in azurerm_storage_container.containers : name => container.name }
}
