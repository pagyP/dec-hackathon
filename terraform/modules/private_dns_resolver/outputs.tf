output "zone_name" {
  value = azurerm_private_dns_zone.resolver.name
}

output "link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.link.id
}
