resource "azurerm_private_dns_zone" "resolver" {
  name                = "example.privatedns.resolver"
  resource_group_name = var.resource_group_name
}

# Note: A full Azure Private DNS Resolver deployment has multiple resources
# (endpoints, rules, etc). For now we provision a DNS zone and link it to the hub VNet.

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "link-to-hub"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.resolver.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}
