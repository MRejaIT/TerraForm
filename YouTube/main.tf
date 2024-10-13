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
  storage_account_name = "shourav143200733123"
}

resource "azurerm_resource_group" "rg" {
  name     = local.azurerm_resource_group
  location = local.location
  
  tags = {
    Name    = "ESL"
    Environment = "Production"
  }
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = local.storage_account_name
  resource_group_name      = local.azurerm_resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2" 

  tags = {
    environment = "staging"
  }

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = local.storage_account_name
  container_access_type = "private"

  depends_on = [ azurerm_storage_account.storageaccount ]
}

resource "azurerm_storage_blob" "blob" {
  name                   = "sample.txt"
  storage_account_name   = local.storage_account_name
  storage_container_name = "data"
  type                   = "Block"
  source                 = "sample.txt"

  depends_on = [ azurerm_storage_container.container ]
}