// Optional VPN simulation between hub and a local 'on-prem' gateway
module "vpn" {
  source               = "./modules/vpn"
  prefix               = var.prefix
  resource_group_name  = module.rg.name
  location             = var.location
  gateway_subnet_id    = module.hub_vnet.gateway_subnet_id
  create_vpn           = var.create_vpn
  vpn_sku              = var.vpn_sku
  onprem_gateway_ip    = var.onprem_gateway_ip
  onprem_address_space = var.onprem_address_space
  vpn_shared_key       = var.vpn_shared_key
}
