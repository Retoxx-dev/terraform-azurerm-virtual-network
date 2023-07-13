#################################################################
# GENERAL
#################################################################

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Kubernetes Cluster."
}

variable "location" {
  type        = string
  description = "(Required) The location in which to create the Kubernetes Cluster."
}

#################################################################
# VIRTUAL NETWORK
#################################################################

variable "name" {
  type        = string
  description = "(Required) The name of the Virtual Network."
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the Virtual Network."
}

variable "bgp_community" {
  type        = string
  default     = null
  description = " (Optional) The BGP community attribute in format <as-number>:<community-value>."
}

variable "ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })
  default     = null
  description = "(Optional) A configuration block for DDoS protection plan."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "(Optional) List of IP addresses of DNS servers."
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
}

variable "flow_timeout_in_minutes" {
  type        = number
  default     = null
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

#################################################################
# SUBNETS
#################################################################

variable "subnets" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
    subnet_delegations = optional(map(object({
      name            = string
      service_name    = string
      service_actions = optional(list(string), null)
    })), {})
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string), null)
    service_endpoint_policy_ids                   = optional(list(string), null)
  }))
  description = "(Required) A list of subnets to create within the Virtual Network."
}

#################################################################
# SECURITY GROUPS
#################################################################
variable "security_groups" {
  type = list(object({
    name      = string
    assign_to = optional(string, null)
    rules = list(object({
      name                                       = string
      description                                = optional(string, null)
      protocol                                   = string
      source_port_range                          = optional(string, null)
      source_port_ranges                         = optional(set(string), null)
      destination_port_range                     = optional(string, null)
      destination_port_ranges                    = optional(list(string), null)
      source_address_prefix                      = optional(string, null)
      source_address_prefixes                    = optional(list(string), null)
      source_application_security_group_ids      = optional(list(string), null)
      destination_address_prefix                 = optional(string, null)
      destination_address_prefixes               = optional(list(string), null)
      destination_application_security_group_ids = optional(list(string), null)
      access                                     = string
      priority                                   = number
      direction                                  = string
    }))
    tags = optional(map(string), null)
  }))
  default     = []
  description = "(Optional) A list of security groups to create."
}