# terraform-azurerm-virtual-network

## Create a virtual network in Azure
With this module you can create a virtual network with subnets and security groups in Azure.

## Usage

### Virtual Network with subnets
```hcl
module "virtual_network" {
  source = "<module-source>"

  resource_group_name = "<resource-group-name>"
  location            = "<location>"

  name = "<virtual-network-name>"

  subnets = [
    {
      name             = "<subnet-name>"
      address_prefixes = ["<subnet-address-prefixes>"]
    },
    {
      name             = "<subnet-name>"
      address_prefixes = ["<subnet-address-prefixes>"]
    }
  ]
}
```

### Virtual Network with subnets and security groups

This module can also create security groups and assign them to subnets.By default they're not being attached so to do that, specify `assign_to` variable with the name of the subnet to which the security group should be assigned.

```hcl
module "virtual_network" {
  source = "<module-source>"

  resource_group_name = "<resource-group-name>"
  location            = "<location>"

  name = "<virtual-network-name>"

  subnets = [
    {
      name             = "<subnet-name>"
      address_prefixes = ["<subnet-address-prefixes>"]
    },
    {
      name             = "<subnet-name>"
      address_prefixes = ["<subnet-address-prefixes>"]
    }
  ]

  security_groups = [
    {
      name = "<security-group-name>"
      assign_to = "<subnet-name>"
      rules = [
        {
          name                       = "<rule-name>"
          protocol                   = "<rule-protocol>"
          access                     = "<rule-access>"
          priority                   = "<rule-priority>"
          direction                  = "<rule-direction>"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  ]
}
```

### Outputs info
If you want to get specific ID of either the subnet or security group, you can use the following syntax:
```hcl
module.virtual_network.subnet_ids["<subnet-name>"]
module.virtual_network.security_group_ids["<security-group-name>"]
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.33 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_bgp_community"></a> [bgp\_community](#input\_bgp\_community) | (Optional) The BGP community attribute in format <as-number>:<community-value>. | `string` | `null` | no |
| <a name="input_ddos_protection_plan"></a> [ddos\_protection\_plan](#input\_ddos\_protection\_plan) | (Optional) A configuration block for DDoS protection plan. | <pre>object({<br>    id     = string<br>    enable = bool<br>  })</pre> | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) List of IP addresses of DNS servers. | `list(string)` | `null` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | (Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created. | `string` | `null` | no |
| <a name="input_flow_timeout_in_minutes"></a> [flow\_timeout\_in\_minutes](#input\_flow\_timeout\_in\_minutes) | (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. | `number` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Virtual Network. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security groups to create. | <pre>list(object({<br>    name      = string<br>    assign_to = optional(string, null)<br>    rules = list(object({<br>      name                                       = string<br>      description                                = optional(string, null)<br>      protocol                                   = string<br>      source_port_range                          = optional(string, null)<br>      source_port_ranges                         = optional(set(string), null)<br>      destination_port_range                     = optional(string, null)<br>      destination_port_ranges                    = optional(list(string), null)<br>      source_address_prefix                      = optional(string, null)<br>      source_address_prefixes                    = optional(list(string), null)<br>      source_application_security_group_ids      = optional(list(string), null)<br>      destination_address_prefix                 = optional(string, null)<br>      destination_address_prefixes               = optional(list(string), null)<br>      destination_application_security_group_ids = optional(list(string), null)<br>      access                                     = string<br>      priority                                   = number<br>      direction                                  = string<br>    }))<br>    tags = optional(map(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) A list of subnets to create within the Virtual Network. | <pre>list(object({<br>    name             = string<br>    address_prefixes = list(string)<br>    subnet_delegations = optional(list(object({<br>      name            = string<br>      service_name    = string<br>      service_actions = optional(list(string), null)<br>    })), null)<br>    private_endpoint_network_policies             = optional(string, "Disabled")<br>    private_link_service_network_policies_enabled = optional(bool, true)<br>    service_endpoints                             = optional(list(string), null)<br>    service_endpoint_policy_ids                   = optional(list(string), null)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the virtual network. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The IDs of the security groups. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The IDs of the subnets within the virtual network. |
<!-- END_TF_DOCS -->