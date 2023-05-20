# Azure Virtual Network Module

Terraform module which creates Virtual Network and Virtual Network Subnets on Azure. This module also creates Network Security Groups and associate them with Subnets.

## Usage

```hcl
# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "this" {
  name     = "rg-terraform-northeu-001"
  location = "northeurope"
}

# Use module to create a Virtual Network with subnets
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
```

## Terraform

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

You can destroy created resources with `terraform destroy`.