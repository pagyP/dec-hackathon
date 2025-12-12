resource "azurerm_virtual_network_peering" "local_to_remote" {
  # make the peering name unique per VNet pair to avoid name collisions
  name                      = "${var.local_vnet_name}-to-${var.remote_vnet_name}"
  resource_group_name       = var.local_resource_group
  virtual_network_name      = var.local_vnet_name
  remote_virtual_network_id = var.remote_vnet_id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "remote_to_local" {
  # reverse the name for the remote side
  name                      = "${var.remote_vnet_name}-to-${var.local_vnet_name}"
  resource_group_name       = var.remote_resource_group
  virtual_network_name      = var.remote_vnet_name
  remote_virtual_network_id = var.local_vnet_id
  allow_virtual_network_access = true
}
