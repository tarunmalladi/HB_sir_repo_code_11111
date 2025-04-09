locals {
  vnet_id             = var.create_vnet ? azurerm_virtual_network.this[0].id : (var.existing_vnet ? data.azurerm_virtual_network.this[0].id : null)
  vnet_name           = var.create_vnet ? azurerm_virtual_network.this[0].name : (var.existing_vnet ? data.azurerm_virtual_network.this[0].name : null)
  resource_group_name = var.create_vnet ? azurerm_virtual_network.this[0].resource_group_name : (var.existing_vnet ? data.azurerm_virtual_network.this[0].resource_group_name : null)
  vnet_location       = var.create_vnet ? azurerm_virtual_network.this[0].location : (var.existing_vnet ? data.azurerm_virtual_network.this[0].location : null)
  vnet_address_space  = var.create_vnet ? azurerm_virtual_network.this[0].address_space : (var.existing_vnet ? data.azurerm_virtual_network.this[0].address_space : null)

  vnet_subnets = var.create_vnet ? values(azurerm_subnet.this)[*].id : (var.existing_vnet ? flatten([for vnet in data.azurerm_virtual_network.this : vnet.subnets[*].id]) : [])
}

output "vnet_id" {
  description = "The id of the vNet"
  value       = local.vnet_id
  sensitive   = false
}

output "vnet_name" {
  description = "The Name of the vNet"
  value       = local.vnet_name
  sensitive   = false
}

output "resource_group_name" {
  description = "The Name of the resource group"
  value       = local.resource_group_name
  sensitive   = false
}

output "vnet_location" {
  description = "The location of the vNet"
  value       = local.vnet_location
  sensitive   = false
}

output "vnet_address_space" {
  description = "The address space of the vNet"
  value       = local.vnet_address_space
  sensitive   = false
}
