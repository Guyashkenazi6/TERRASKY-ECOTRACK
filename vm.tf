resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "ecotrack-vm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "ecotrack-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
    
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.boot_diag.primary_blob_endpoint
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_account" "diag" {
  name                     = "diag${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_account" "boot_diag" {
  name                     = "bootdiag${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false


}