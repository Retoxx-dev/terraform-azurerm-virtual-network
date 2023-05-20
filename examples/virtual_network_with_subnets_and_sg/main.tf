provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-terraform-northeu-001"
  location = "northeurope"
}

module "virtual_network" {
  source = "retoxx-dev/virtual-network/azurerm"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "vnet-terraform-northeu-001"
  address_space = ["192.168.0.0/16"]

  subnets = [
    {
      name             = "snet-terraform-northeu-001"
      address_prefixes = ["192.168.0.0/17"]
    },
    {
      name             = "snet-terraform-northeu-002"
      address_prefixes = ["192.168.128.0/17"]
    }
  ]

  security_groups = [
    {
      name = "sg-terraform-northeu-001"
      assign_to = "snet-terraform-northeu-001"
      rules = [
        {
          name                       = "rule1"
          protocol                   = "Tcp"
          access                     = "Allow"
          priority                   = 100
          direction                  = "Inbound"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "rule2"
          protocol                   = "Udp"
          access                     = "Allow"
          priority                   = 101
          direction                  = "Inbound"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
      ]
    },
    {
      name      = "sg-terraform-northeu-002"
      assign_to = "snet-terraform-northeu-002"
      rules = [
        {
          name                       = "rule1"
          protocol                   = "Tcp"
          access                     = "Allow"
          priority                   = 100
          direction                  = "Inbound"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "rule2"
          protocol                   = "Udp"
          access                     = "Allow"
          priority                   = 101
          direction                  = "Inbound"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
      ]
    }
  ]

  tags = {
    "Environment" = "Production"
  }
}