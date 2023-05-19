#################################################################
# VIRTUAL NETWORK
#################################################################

output "name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the virtual network."
}

output "id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the virtual network."
}

#################################################################
# SUBNETS
#################################################################

output "subnet_ids" {
  value       = { for subnet in azurerm_subnet.this : subnet.name => subnet.id }
  description = "The IDs of the subnets within the virtual network."
}

#################################################################
# SECURITY GROUPS
#################################################################

output "security_group_ids" {
  value       = { for sg in azurerm_network_security_group.this : sg.name => sg.id }
  description = "The IDs of the security groups."
}