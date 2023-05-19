locals {
  subnet_ids = { for subnet in azurerm_subnet.this : subnet.name => subnet.id }

  security_group_ids = { for sg in azurerm_network_security_group.this : sg.name => sg.id }
}