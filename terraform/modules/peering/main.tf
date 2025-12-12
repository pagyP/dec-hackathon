resource "azurerm_virtual_network_peering" "local_to_remote" {
  name                      = "local-to-remote"
  resource_group_name       = var.local_resource_group
  virtual_network_name      = var.local_vnet_name
  remote_virtual_network_id = var.remote_vnet_id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "remote_to_local" {
  name                      = "remote-to-local"
  resource_group_name       = var.remote_resource_group
  virtual_network_name      = var.remote_vnet_name
  remote_virtual_network_id = var.local_vnet_id
  allow_virtual_network_access = true
}
