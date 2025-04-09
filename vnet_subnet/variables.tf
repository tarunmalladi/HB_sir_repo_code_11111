variable "vnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cidr_range" {
  type = list(string)
}

variable "create_resource_group" {
  type    = bool
  default = false
}

variable "create_vnet" {
  type    = bool
  default = true
}

variable "existing_vnet" {
  type    = bool
  default = false
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr                                         = string
    nsg_association                              = string
    route_table                                  = string
    enforce_private_link_endpoint_network_policies = bool
    service_endpoint                             = bool
    service_delegation                           = bool
    del_name                                        = string
    service_delegation_name                         = string
  }))
}

variable "serviceendpoint" {
  type = list(string)
}

variable "environment" {
  type = string
}

#variable "app_owner" {
#  type = string
#}

#variable "app_name" {
#  type = string
#}

variable "ask_id" {
  type = string
}

variable "description" {
  type = string
}

variable "create_nsg" {
  type    = bool
  default = false
}


variable "nsgs" {
  description = "List of NSGs to be created, each containing its own set of security rules."
  type = list(object({
    name  = string
    rules = list(object({
      name                      = string
      priority                  = number
      direction                 = string
      access                    = string
      protocol                  = string
      source_port_range         = optional(string)
      source_port_ranges        = optional(list(string))
      destination_port_range    = optional(string)
      destination_port_ranges   = optional(list(string))
      source_address_prefix     = optional(string)
      source_address_prefixes   = optional(list(string))
      destination_address_prefix = optional(string)
      destination_address_prefixes = optional(list(string))
    }))
  }))
}



variable "existing_nsgs" {
  description = "List of existing NSG definitions"
  type        = list(object({
    name                = string
    resource_group_name = string
  }))
  default = []
}

variable "existing_nsg" {
  type    = bool
  default = false
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "create_route_table" {
  type    = bool
  default = false
}

variable "existing_route_table" {
  type    = bool
  default = false
}

variable "route_table_name" {
  type = string
  default = ""
}

variable "route_table_routes" {
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
  }))
  default = []
}
