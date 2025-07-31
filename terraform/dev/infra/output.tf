output "function_app_id" {
  value = module.function.function_endpoint
}
output "function_app_name" {
  value       = module.function.azurerm_function_app.func.name
  description = "The name of the Azure Function App"
}
