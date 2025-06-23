resource "azurerm_resource_group" "rg" {
  name     = "rg-ecotrack"
  location = var.location
  tags = {
    environment = "production"
    owner       = "EcoTrack"
  }
}