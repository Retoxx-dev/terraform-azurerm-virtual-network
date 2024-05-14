#################################################################
# VIRTUAL NETWORK
#################################################################

resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  bgp_community = var.bgp_community

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [1] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.id
    }
  }

  dns_servers             = var.dns_servers
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  tags = var.tags
}

#################################################################
# VIRTUAL NETWORK - SUBNETS
#################################################################

resource "azurerm_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.subnet_delegations != null ? each.value.subnet_delegations : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_actions
      }
    }
  }

  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  service_endpoints           = each.value.service_endpoints
  service_endpoint_policy_ids = each.value.service_endpoint_policy_ids
}

#################################################################
# NETWORK SECURITY GROUPS
#################################################################

resource "azurerm_network_security_group" "this" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location


  dynamic "security_rule" {
    for_each = each.value.rules != null ? each.value.rules : []
    content {
      name                                       = security_rule.value.name
      description                                = security_rule.value.description
      protocol                                   = security_rule.value.protocol
      source_port_range                          = security_rule.value.source_port_range
      source_port_ranges                         = security_rule.value.source_port_ranges
      destination_port_range                     = security_rule.value.destination_port_range
      destination_port_ranges                    = security_rule.value.destination_port_ranges
      source_address_prefix                      = security_rule.value.source_address_prefix
      source_address_prefixes                    = security_rule.value.source_address_prefixes
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      destination_address_prefixes               = security_rule.value.destination_address_prefixes
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
      access                                     = security_rule.value.access
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
    }
  }

  tags = each.value.tags
}

#################################################################
# NETWORK SECURITY GROUPS - ASSOCIATIONS
#################################################################

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for sg in var.security_groups : sg.name => sg if sg.assign_to != null }
  subnet_id                 = local.subnet_ids[each.value.assign_to]
  network_security_group_id = local.security_group_ids[each.value.name]
}
