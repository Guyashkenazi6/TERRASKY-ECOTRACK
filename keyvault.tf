data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = "kv${random_string.suffix.result}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = azurerm_linux_web_app.app.identity[0].principal_id
    secret_permissions = ["Get"]
  }


  tags = {
    environment = "production"
  }
}