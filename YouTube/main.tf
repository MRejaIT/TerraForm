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
  subscription_id = "ea4807db-8132-4dfb-b7a2-d0c68853542c"
  tenant_id = "479e29ce-1a7a-4ee2-88c6-f4c3370ab5a1"
  client_id = "0fd8a585-8613-46fd-8833-2d64838e4938"
  client_secret = "OV_8Q~kttYWQhB2V7qd8C4w6LfNvDYKFMRje~aeV"

  features {
    
  }
}