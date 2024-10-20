resource "azurerm_resource_group" "rgdetails" {
  name     = local.azurerm_resource_group
  location = local.location
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccountnameshourav28746712365473856"
  resource_group_name      = local.azurerm_resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [ azurerm_resource_group.rgdetails ]

}
