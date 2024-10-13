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

  #subscription_id = "ea4807db-8132-4dfb-b7a2-d0c68853542c"
  #tenant_id       = "479e29ce-1a7a-4ee2-88c6-f4c3370ab5a1"
  #client_id       = "0fd8a585-8613-46fd-8833-2d64838e4938"
  #client_secret   = "OV_8Q~kttYWQhB2V7qd8C4w6LfNvDYKFMRje~aeV"
}

resource "azurerm_resource_group" "rg" {
  name     = "TerraForm-RG-SEA-01"
  location = "Southeast Asia"
  
  tags = {
    Name    = "ESL"
    Environment = "Production"
  }
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "shourav143200733"
  resource_group_name      = "TerraForm-RG-SEA-01"
  location                 = "Southeast Asia"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2" 

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = "shourav143200733"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "sample.txt"
  storage_account_name   = "shourav143200733"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "sample.txt"
}