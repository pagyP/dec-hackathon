module "hub_vnet" {
  source                = "./modules/vnet"
  name                  = "${var.prefix}-hub-vnet"
  location              = var.location
  resource_group_name   = module.rg.name
  address_space         = var.hub_vnet_cidr
  create_gateway_subnet = var.create_vpn
  gateway_subnet_cidr   = var.gateway_subnet_cidr
  subnets               = concat(var.hub_subnets, [var.azure_bastion_subnet], var.private_dns_resolver_subnets)
}

module "bastion" {
  source              = "./modules/bastion"
  prefix              = var.prefix
  resource_group_name = module.rg.name
  location            = var.location
  bastion_subnet_id   = module.hub_vnet.subnets["AzureBastionSubnet"]
  create_bastion      = var.create_bastion
}

module "private_dns_resolver" {
  source              = "./modules/private_dns_resolver"
  prefix              = var.prefix
  resource_group_name = module.rg.name
  location            = var.location
  vnet_id             = module.hub_vnet.id
}

module "spoke_app_vnet" {
  source              = "./modules/vnet"
  name                = "${var.prefix}-spoke-app-vnet"
  location            = var.location
  resource_group_name = module.rg.name
  address_space       = var.spoke_app_vnet_cidr
  subnets             = var.spoke_app_subnets
}

module "spoke_onprem_vnet" {
  source              = "./modules/vnet"
  name                = "${var.prefix}-spoke-onprem-vnet"
  location            = var.location
  resource_group_name = module.rg.name
  address_space       = var.spoke_onprem_vnet_cidr
  subnets             = var.spoke_onprem_subnets
}

module "peering_hub_spoke_app" {
  source                = "./modules/peering"
  local_resource_group  = module.rg.name
  local_vnet_name       = module.hub_vnet.name
  local_vnet_id         = module.hub_vnet.id
  remote_resource_group = module.rg.name
  remote_vnet_name      = module.spoke_app_vnet.name
  remote_vnet_id        = module.spoke_app_vnet.id
}

module "peering_hub_spoke_onprem" {
  source                = "./modules/peering"
  local_resource_group  = module.rg.name
  local_vnet_name       = module.hub_vnet.name
  local_vnet_id         = module.hub_vnet.id
  remote_resource_group = module.rg.name
  remote_vnet_name      = module.spoke_onprem_vnet.name
  remote_vnet_id        = module.spoke_onprem_vnet.id
}
