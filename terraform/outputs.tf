output "random_name" {
  description = "Generated random pet name"
  value       = random_pet.example.id
}

output "hub_vnet_id" {
  description = "Hub VNet ID"
  value       = module.hub_vnet.id
}

output "spoke_app_vnet_id" {
  description = "Spoke (app) VNet ID"
  value       = module.spoke_app_vnet.id
}

output "spoke_onprem_vnet_id" {
  description = "Spoke (onprem) VNet ID"
  value       = module.spoke_onprem_vnet.id
}

output "hub_to_spoke_app_peering" {
  value = module.peering_hub_spoke_app.local_to_remote_id
}

output "hub_to_spoke_onprem_peering" {
  value = module.peering_hub_spoke_onprem.local_to_remote_id
}

output "vpn_gateway_id" {
  description = "VPN gateway (if created)"
  value       = var.create_vpn ? module.vpn.hub_vpn_id : ""
}
