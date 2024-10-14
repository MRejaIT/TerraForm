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
}

resource "azurerm_resource_group" "rg" {
  name     = local.azurerm_resource_group
  location = local.location
  
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VNet-01"
  location            = local.location
  resource_group_name = local.azurerm_resource_group
  address_space       = ["10.0.0.0/16"]


  subnet {
    name             = "App-Subnet"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "DB-Subnet"
    address_prefixes = ["10.0.2.0/24"]
  }
  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic0001"
  location            = local.location
  resource_group_name = local.azurerm_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.vnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_virtual_network.vnet]
}