resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    "ent:environment" = var.environment
    "ent:ASKID"       = var.ask_id
    "ent:Description" = var.description
  }
}

data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  # Determine if cidr_range is required based on create_vnet
  cidr_range_required = var.create_vnet ? var.cidr_range : []
}

resource "azurerm_virtual_network" "this" {
  count = var.create_vnet ? 1 : 0
  name                = var.vnet_name
  location            = var.location
  address_space       = var.cidr_range     #var.create_vnet ? [local.cidr_range_required] : []
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  tags = {
    "ent:environment" = var.environment
    "ent:ASKID"       = var.ask_id
    "ent:Description" = var.description
  }
}

data "azurerm_virtual_network" "this" {
  count = var.existing_vnet ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets
  name     = each.key
  resource_group_name  = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  virtual_network_name = var.create_vnet ? azurerm_virtual_network.this[0].name : data.azurerm_virtual_network.this[0].name
  address_prefixes       =  [each.value.cidr]  
  service_endpoints    = lookup(each.value, "service_endpoint", null) == null ? null : var.serviceendpoint
  #enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null) == null ? false : each.value.enforce_private_link_endpoint_network_policies

  dynamic "delegation" {
    for_each = each.value.service_delegation ? [1] : []

    content {
      name = lookup(each.value, "del_name")

      service_delegation {
        name    = lookup(each.value, "service_delegation_name")
        actions =["Microsoft.Network/networkinterfaces/*",
                  "Microsoft.Network/publicIPAddresses/join/action",
                  "Microsoft.Network/publicIPAddresses/read",
                  "Microsoft.Network/virtualNetworks/read",
                  "Microsoft.Network/virtualNetworks/subnets/action",
                  "Microsoft.Network/virtualNetworks/subnets/join/action",
                  "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
                  "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
      }
    }
  }
}



resource "azurerm_network_security_group" "nsg" {
  for_each            = var.create_nsg ? { for idx, nsg in var.nsgs : idx => nsg } : {}
  name                = each.value.name
  location            = var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name

  dynamic "security_rule" {
    for_each = each.value.rules

    content {
      name                        = security_rule.value.name
      priority                    = security_rule.value.priority
      direction                   = security_rule.value.direction
      access                      = security_rule.value.access
      protocol                    = security_rule.value.protocol

      source_port_range           = try(security_rule.value.source_port_range, null)
      source_port_ranges          = try(security_rule.value.source_port_ranges, null)

      destination_port_range      = try(security_rule.value.destination_port_range, null)
      destination_port_ranges     = try(security_rule.value.destination_port_ranges, null)

      source_address_prefixes     = try(security_rule.value.source_address_prefixes, [])
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, [])

      source_address_prefix       = try(security_rule.value.source_address_prefix, null)
      destination_address_prefix  = try(security_rule.value.destination_address_prefix, null)
    }
  }

  tags = {
    "ent:environment" = var.environment
    "ent:ASKID"       = var.ask_id
    "ent:Description" = var.description
  }
}


resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = { for key, value in var.subnets : key => value if value.nsg_association != "" }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = var.create_nsg ? lookup({ for ns in azurerm_network_security_group.nsg : ns.name => ns.id }, each.value.nsg_association, null) : data.azurerm_network_security_group.existing_nsg[each.value.nsg_association].id
}

locals {
  create_nsg_map = { for nsg in var.existing_nsgs : nsg.name => nsg }
  existing_nsg_data = var.existing_nsg && length(var.existing_nsgs) > 0
}

data "azurerm_network_security_group" "existing_nsg" {
  for_each = local.existing_nsg_data ? local.create_nsg_map : {}
  name     = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_route_table" "route_table" {
  count               = var.create_route_table &&  !var.existing_route_table ? 1 : 0
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  #disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = var.route_table_routes
    content {
      name           = route.value.name
      address_prefix = route.value.address_prefix
      next_hop_type  = route.value.next_hop_type
    }
  }

  tags = {
    "ent:environment" = var.environment
    "ent:ASKID"       = var.ask_id
    "ent:Description" = var.description
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = { for key, value in var.subnets : key => value if value.route_table != "" }
  subnet_id     = azurerm_subnet.this[each.key].id
  route_table_id = var.create_route_table ? azurerm_route_table.route_table[0].id : data.azurerm_route_table.existing_route_table[0].id
}

data "azurerm_route_table" "existing_route_table" {
  count = !var.create_route_table && var.existing_route_table ? 1 : 0
  name  = var.route_table_name
  resource_group_name = var.resource_group_name
}
