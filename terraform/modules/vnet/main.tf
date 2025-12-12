resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "gateway" {
  count               = var.create_gateway_subnet ? 1 : 0
  name                = "GatewaySubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes    = [var.gateway_subnet_cidr]
}

# create user-provided subnets
resource "azurerm_subnet" "custom" {
  for_each            = { for s in var.subnets : s.name => s }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes    = [each.value.address_prefix]
  service_endpoints   = try(each.value.service_endpoints, [])
}
