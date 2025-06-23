output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "app_service_url" {
  value = azurerm_linux_web_app.app.default_hostname
}