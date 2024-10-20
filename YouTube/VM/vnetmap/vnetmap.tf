terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}

  subscription_id = "f432a24d-fc29-4e0a-9868-05f6e415e557"
  #tenant_id       = "479e29ce-1a7a-4ee2-88c6-f4c3370ab5a1"
  #client_id       = "0fd8a585-8613-46fd-8833-2d64838e4938"
  #client_secret   = "OV_8Q~kttYWQhB2V7qd8C4w6LfNvDYKFMRje~aeV"
}

locals {
  azurerm_resource_group = "TerraForm-RG-SEA-01"
  location = "Southeast Asia"

  vitrual_network = {
    name = "VNet-01"
    address_space = "10.0.0.0/16"
  }

    subnet=[
        {
            name="App-Subnet"
            address_prefixes="10.0.1.0/24"
        },

        {
            name="DB-Subnet"
            address_prefixes="10.0.2.0/24"
        }

    ]
}

resource "azurerm_resource_group" "rgdetails" {
  name     = local.azurerm_resource_group
  location = local.location
  
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vitrual_network.name
  location            = local.location
  resource_group_name = local.azurerm_resource_group
  address_space       = [local.vitrual_network.address_space]

  depends_on = [ azurerm_resource_group.rgdetails ]
}

resource "azurerm_subnet" "appsubnet" {
  name                 = local.subnet[0].name
  resource_group_name  = local.azurerm_resource_group
  virtual_network_name = local.vitrual_network.name
  address_prefixes     = [local.subnet[0].address_prefixes]

  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_subnet" "dbsubnet" {
  name                 = local.subnet[1].name
  resource_group_name  = local.azurerm_resource_group
  virtual_network_name = local.vitrual_network.name
  address_prefixes     = [local.subnet[1].address_prefixes]

  depends_on = [ azurerm_virtual_network.vnet]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic0001"
  location            = local.location
  resource_group_name = local.azurerm_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  depends_on = [ azurerm_subnet.appsubnet ]
}

output "appsubnet-id" {
  value = azurerm_subnet.appsubnet.id
  
}

resource "azurerm_public_ip" "pip" {
  name                = "appsrv-pip"
  resource_group_name = local.azurerm_resource_group
  location            = local.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.rgdetails ]

}

resource "azurerm_network_security_group" "nsgdetails" {
  name                = "AppNSG-01"
  location            = local.location
  resource_group_name = local.azurerm_resource_group

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.rgdetails ]
}

resource "azurerm_subnet_network_security_group_association" "nsglink" {
  subnet_id                 = azurerm_subnet.appsubnet.id
  network_security_group_id = azurerm_network_security_group.nsgdetails.id
}

resource "azurerm_windows_virtual_machine" "win-vm" {
  name                = "FTVM"
  resource_group_name = local.azurerm_resource_group
  location            = local.location
  size                = "Standard_B2als_v2"
  admin_username      = "azuser"
  admin_password      = "Asdf123456789"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_resource_group.rgdetails, azurerm_network_interface.nic ]
}