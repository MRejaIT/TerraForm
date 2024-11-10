terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
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

resource "azurerm_resource_group" "Nur-ARM-TF" {
  name     = "Nur-ARM-TF"
  location = "southeast asia"
}


# Virtual Network
resource "azurerm_virtual_network" "tf_vnet" {
  name                = "tf-vnet"
  location            = "southeast asia"
  resource_group_name = "Nur-ARM-TF"
  address_space       = ["10.10.0.0/16"]
  depends_on = [ azurerm_resource_group.Nur-ARM-TF ]
}

resource "azurerm_subnet" "AppSubnet" {
  name                 = "AppSubnet"
  resource_group_name  = "Nur-ARM-TF"
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.10.10.0/24"]

  depends_on = [
    azurerm_virtual_network.tf_vnet
  ]
}
resource "azurerm_subnet" "dbSubnet" {
  name                 = "dbSubnet"
  resource_group_name  = "Nur-ARM-TF"
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.10.20.0/24"]

  depends_on = [
    azurerm_virtual_network.tf_vnet
  ]
}
# Network Interface
resource "azurerm_network_interface" "tf_nIC" {
  name                = "tf_nIC"
  location            = "southeast asia"
  resource_group_name = "Nur-ARM-TF"

  ip_configuration {
    name                          = "internal"
 #   subnet_id                     = "AppSubnet"
    subnet_id = azurerm_subnet.AppSubnet.id

    private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_subnet_network_security_group_association" "nsglink" {
  subnet_id                 = azurerm_subnet.AppSubnet.id
  network_security_group_id = azurerm_network_security_group.nsgdetails.id
}

# Virtual machine
resource "azurerm_virtual_machine" "tf_vm" {
  name                = "tf-vm"
  location            = "East US"  # Use a region where Windows Server 2022 is available
  resource_group_name = azurerm_resource_group.Nur-ARM-TF.name
  network_interface_ids = [azurerm_network_interface.tf_nIC.id]
  vm_size             = "Standard_B1s"
  #network_interface_ids = ["${element(azurerm_network_interface.tf_nIC.id, count.index)}"]

# OS Disk
 storage_os_disk {
    name              = "tf-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = 128
   # storage_account_type = "Standard_LRS" 
  }

# OS Imgae
storage_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2019-datacenter-gensecond"
  version   = "latest"
}
# Admin Credential
  os_profile {
    computer_name  = "tf-vm"
    admin_username = "tfadm"
    admin_password = "tF@1243."  # Update with a strong password
  }
  depends_on = [ azurerm_resource_group.Nur-ARM-TF,azurerm_network_interface.tf_nIC ]
}
