resource "azurerm_public_ip" "hub_gw_ip" {
  count               = var.create_vpn ? 1 : 0
  name                = "${var.prefix}-hub-gw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "hub_vpn" {
  count               = var.create_vpn ? 1 : 0
  name                = "${var.prefix}-hub-vpngw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku  = var.vpn_sku
  type = "Vpn"
  vpn_type = "RouteBased"

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.hub_gw_ip[0].id
    subnet_id            = var.gateway_subnet_id
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  count               = var.create_vpn ? 1 : 0
  name                = "${var.prefix}-onprem-lngw"
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.onprem_gateway_ip
  address_space       = [var.onprem_address_space]
}

resource "azurerm_virtual_network_gateway_connection" "site_to_site" {
  count = var.create_vpn ? 1 : 0
  name                = "${var.prefix}-s2s-conn"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_vpn[0].id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem[0].id
  type = "IPsec"
  shared_key      = var.vpn_shared_key
}
