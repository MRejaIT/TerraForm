import {
  to = azurerm_resource_group.rgdetails
  id = "/subscriptions/f432a24d-fc29-4e0a-9868-05f6e415e557/resourceGroups/TerraForm-RG-SEA-02"
}

import {
  to = azurerm_managed_disk.managediskdetails
  id = "/subscriptions/f432a24d-fc29-4e0a-9868-05f6e415e557/resourceGroups/TerraForm-RG-SEA-02/providers/Microsoft.Compute/disks/mg-disk-01"
}
resource "azurerm_resource_group" "rgdetails" {
  name     = local.azurerm_resource_group
  location = local.location
}

resource "azurerm_storage_account" "example" {
  name                     = "shourav365473856"
  resource_group_name      = local.azurerm_resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [ azurerm_resource_group.rgdetails ]

}

resource "azurerm_managed_disk" "managediskdetails" {
  name                 = "mg-disk-01"
  location             = local.location
  resource_group_name  = local.azurerm_resource_group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"

  depends_on = [ azurerm_resource_group.rgdetails ]

}