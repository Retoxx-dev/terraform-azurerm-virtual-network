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

  tags = {
    "Environment" = "Production"
  }
}