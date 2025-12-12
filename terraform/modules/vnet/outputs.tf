output "id" {
  value = azurerm_virtual_network.this.id
}

output "name" {
  value = azurerm_virtual_network.this.name
}

output "gateway_subnet_id" {
  value = length(azurerm_subnet.gateway) > 0 ? azurerm_subnet.gateway[0].id : ""
}

output "subnets" {
  description = "Map of subnet name => id for subnets created by the module"
  value       = { for s in azurerm_subnet.custom : s.name => s.id }
}
