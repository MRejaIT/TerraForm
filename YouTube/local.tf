locals {
  azurerm_resource_group = "TerraForm-RG-SEA-02"
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