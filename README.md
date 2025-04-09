# ORX-PCO-PAPortal-prod-f8462eadb28f
# Azure Virtual Network (VNet) Terraform Module

## Overview

This Terraform module provisions a Virtual Network (VNet) in Azure, including subnets, Network Security Groups (NSGs), and Route Tables. It supports the conditional creation of resources and can associate existing resources as well.

## Resources

The module supports the following resources:
- Resource Group
- Virtual Network
- Subnets
- Network Security Groups (NSGs)
- Route Tables

## Usage

```hcl
module "vnet" {
  source              = "./path/to/your/module"
  create_resource_group = true
  resource_group_name = "example-rg"
  location            = "West Europe"
  environment         = "production"
  app_owner           = "team@example.com"
  app_name            = "example-app"
  
  vnet_name           = "example-vnet"
  cidr_range          = "10.0.0.0/16"
  
  subnets = {
    subnet1 = {
      cidr                                  = "10.0.1.0/24"
      service_endpoint                      = "Microsoft.Storage"
      enforce_private_link_endpoint_network_policies = true
      nsg_association                       = "existing-nsg1"
      route_table                           = "existing-route-table"
      service_delegation                    = true
      del_name                              = "example-del"
      service_delegation_name               = "Microsoft.Web/serverFarms"
    }
  }

  create_nsg        = true
  existing_nsg      = false
  nsg_name          = "example-nsg"
  nsg_rules         = {
    rule1 = {
      name                       = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  create_route_table = true
  existing_route_table = false
  route_table_name    = "example-route-table"
  route_table_routes  = {
    route1 = {
      name           = "example-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }

  existing_nsgs = [
    {
      name               = "existing-nsg1"
      resource_group_name = "existing-rg"
    }
  ]
}
```

## Variables

| Name                                            | Description                                                                 | Type           | Default | Required |
|-------------------------------------------------|-----------------------------------------------------------------------------|----------------|---------|----------|
| `create_resource_group`                         | Whether to create a new Resource Group                                      | `bool`         | `true`  | no       |
| `resource_group_name`                           | The name of the Resource Group                                              | `string`       | n/a     | yes      |
| `location`                                      | The Azure location where the resources will be created                      | `string`       | n/a     | yes      |
| `environment`                                   | The environment tag (e.g., production, staging)                             | `string`       | n/a     | yes      |
| `app_owner`                                     | The application owner tag                                                   | `string`       | n/a     | yes      |
| `app_name`                                      | The application name tag                                                    | `string`       | n/a     | yes      |
| `vnet_name`                                     | The name of the Virtual Network                                             | `string`       | n/a     | yes      |
| `cidr_range`                                    | The CIDR range for the Virtual Network                                      | `string`       | n/a     | yes      |
| `subnets`                                       | A map of subnets to create                                                  | `map(any)`     | n/a     | yes      |
| `create_nsg`                                    | Whether to create a new Network Security Group                              | `bool`         | `true`  | no       |
| `existing_nsg`                                  | Whether to use an existing Network Security Group                           | `bool`         | `false` | no       |
| `nsg_name`                                      | The name of the Network Security Group                                      | `string`       | n/a     | no       |
| `nsg_rules`                                     | A map of security rules to create in the NSG                                | `map(any)`     | `{}`    | no       |
| `create_route_table`                            | Whether to create a new Route Table                                         | `bool`         | `true`  | no       |
| `existing_route_table`                          | Whether to use an existing Route Table                                      | `bool`         | `false` | no       |
| `route_table_name`                              | The name of the Route Table                                                 | `string`       | n/a     | no       |
| `route_table_routes`                            | A map of routes to create in the Route Table                                | `map(any)`     | `{}`    | no       |
| `existing_nsgs`                                 | A list of existing NSGs to associate with subnets                           | `list(object)` | `[]`    | no       |

## Outputs

| Name                    | Description                                    |
|-------------------------|------------------------------------------------|
| `vnet_id`               | The ID of the newly created Virtual Network    |
| `vnet_name`             | The Name of the newly created Virtual Network  |
| `resource_group_name`   | The Name of the Resource Group                 |
| `vnet_location`         | The location of the newly created Virtual Network |
| `vnet_address_space`    | The address space of the newly created Virtual Network |
| `vnet_subnets`          | The IDs of subnets created inside the new Virtual Network |
## Details

### Resource Group

The module can create a new resource group or use an existing one based on the `create_resource_group` variable.

### Virtual Network

The virtual network is created with a specified CIDR range.

### Subnets

Subnets are defined in a map and can include service endpoints, private link policies, NSG associations, and route table associations.

### Network Security Groups (NSGs)

The module can create a new NSG or use an existing one based on the `create_nsg` and `existing_nsg` variables. NSG rules are defined in a map.

### Route Tables

The module can create a new Route Table or use an existing one based on the `create_route_table` and `existing_route_table` variables. Routes are defined in a map.

## Examples

### Creating a New VNet with Subnets and NSG

```hcl
module "vnet" {
  source              = "./path/to/your/module"
  create_resource_group = true
  resource_group_name = "example-rg"
  location            = "West Europe"
  environment         = "production"
  app_owner           = "team@example.com"
  app_name            = "example-app"
  
  vnet_name           = "example-vnet"
  cidr_range          = "10.0.0.0/16"
  
  subnets = {
    subnet1 = {
      cidr                                  = "10.0.1.0/24"
      service_endpoint                      = "Microsoft.Storage"
      enforce_private_link_endpoint_network_policies = true
      nsg_association                       = "example-nsg"
      route_table                           = "example-route-table"
      service_delegation                    = true
      del_name                              = "example-del"
      service_delegation_name               = "Microsoft.Web/serverFarms"
    }
  }

  create_nsg        = true
  nsg_name          = "example-nsg"
  nsg_rules         = {
    rule1 = {
      name                       = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  create_route_table = true
  route_table_name    = "example-route-table"
  route_table_routes  = {
    route1 = {
      name           = "example-route"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }
}
```

### Using Existing NSGs and Route Tables

```hcl
module "vnet" {
  source              = "./path/to/your/module"
  create_resource_group = true
  resource_group_name = "example-rg"
  location            = "West Europe"
  environment         = "production"
  app_owner           = "team@example.com"
  app_name            = "example-app"
  
  vnet_name           = "example-vnet"
  cidr_range          = "10.0.0.0/16"
  
  subnets = {
    subnet1 = {
      cidr                                  = "10.0.1.0/24"
      service_endpoint                      = "Microsoft.Storage"
      enforce_private_link_endpoint_network_policies = true
      nsg_association                       = "existing-nsg1"
      route_table                           = "existing-route-table"
      service_delegation                    = true
      del_name                              = "example-del"
      service_delegation_name               = "Microsoft.Web/serverFarms"
    }
  }

  create_nsg        = false
  existing_nsg      = true
  create_route_table = false
  existing_route_table = true

  existing_nsgs = [
    {
      name               = "existing-nsg1"
      resource_group_name = "existing-rg"
    }
  ]
}
```

##
