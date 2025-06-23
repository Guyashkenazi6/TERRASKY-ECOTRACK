resource "azurerm_service_plan" "plan" {
  name                = "ecotrack-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    environment = "production"
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "ecotrack-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.10"
    }
    minimum_tls_version = "1.2"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_private_endpoint" "app_private_endpoint" {
  name                = "app-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "app-priv-connection"
    private_connection_resource_id = azurerm_linux_web_app.app.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  tags = {
    environment = "production"
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "app_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = azurerm_subnet.app.id
}