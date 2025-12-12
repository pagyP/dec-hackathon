output "bastion_id" {
  value = length(azurerm_bastion_host.this) > 0 ? azurerm_bastion_host.this[0].id : ""
}

output "public_ip_id" {
  value = length(azurerm_public_ip.bastion) > 0 ? azurerm_public_ip.bastion[0].id : ""
}
