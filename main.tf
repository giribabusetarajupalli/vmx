resource "random_string" "password" {
  lower = true
  special = true
  number = true
  upper = true
  length = 12
}

resource "azurerm_resource_group" "rg" {
  name = var.rg
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet
  location = azurerm_resource_group.rg.location
  address_space = var.vnet_address_space
  resource_group_name = azurerm_resource_group.rg.name

}
resource "azurerm_subnet" "subnet" {
  name = var.subnet
  resource_group_name = azurerm_resource_group.rg.name
  address_prefixes = var.subnet_address_space
  virtual_network_name = var.vnet

}
resource "azurerm_network_security_group" "nsg" {
  name = var.nsg
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
    security_rule {
    name                       = "port_3389"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "nic" {
  name = var.nic
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = "ipconfig"
    private_ip_address_allocation = "dynamic"
    subnet_id = azurerm_subnet.subnet.id

  }
}
resource "azurerm_public_ip" "pip" {
  name = var.pip
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "standard"
}

resource "azurerm_windows_virtual_machine" "main" {
  name = var.vm
  resource_group_name =  azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_username = "Giribabu"
  admin_password = random_string.password.result
  computer_name = "Rithvin"
  size = "Standard_DS1_V2"
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "keyvault" {
  name                       = var.keyvault
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7
access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list"
    ]
  }
}
# data "azurerm_key_vault" "keyvault" {
#   name = "kjhgfhkljhgf00"
#   resource_group_name = azurerm_resource_group.rg.name
  
# }

resource "azurerm_key_vault_secret" "keyvaultSecret" {
  name = var.keyvaultsecret
  value = random_string.password.result
  key_vault_id = azurerm_key_vault.keyvault.id
  
}
