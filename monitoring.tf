resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-ecotrack"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"

  tags = {
    environment = "production"
  }
}

resource "azurerm_virtual_machine_extension" "azuremonitoragent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id          = azurerm_linux_virtual_machine.vm.id
  publisher                   = "Microsoft.Azure.Monitor"
  type                        = "AzureMonitorLinuxAgent"
  type_handler_version        = "1.0"
  auto_upgrade_minor_version  = true

  tags = {
    environment = "production"
  }
}

resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  name                       = "vm-diagnostics"
  target_resource_id         = azurerm_linux_virtual_machine.vm.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostics" {
  name                       = "app-diagnostics"
  target_resource_id         = azurerm_linux_web_app.app.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
  
}

resource "azurerm_monitor_diagnostic_setting" "storage_diagnostics" {
  name                       = "storage-diagnostics"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
  

  # אם תרצה לוגים, בדוק את הקטגוריות המותרות ב-Azure Portal והוסף:
  # enabled_log {
  #   category = "StorageWrite"
  # }
}
