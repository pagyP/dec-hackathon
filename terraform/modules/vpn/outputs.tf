output "hub_vpn_id" {
  value = length(azurerm_virtual_network_gateway.hub_vpn) > 0 ? azurerm_virtual_network_gateway.hub_vpn[0].id : ""
}

output "connection_id" {
  value = length(azurerm_virtual_network_gateway_connection.site_to_site) > 0 ? azurerm_virtual_network_gateway_connection.site_to_site[0].id : ""
}
