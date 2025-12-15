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

  # Optional subnet delegations. Some "custom" VNets require delegated subnets,
  # others do not. This dynamic block creates delegation blocks only when the
  # `delegations` attribute is provided for the subnet in `var.subnets`.
  dynamic "delegation" {
    for_each = each.value.delegations != null ? each.value.delegations : []
    content {
      name = delegation.value.name

      service_delegation {
        name = delegation.value.service_delegation_name
      }
    }
  }
}
