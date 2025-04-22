module "vnet_subnet" {
  source                  = "./vnet_subnet"
  create_vnet             = true
  existing_vnet           = false
  vnet_name               = "orx-aim-prod-vn"
  location                = "Central India"
  cidr_range              = ["10.40.20.0/22"]
  create_resource_group   = true
  resource_group_name     = "orx-aim-prod-rg"
  resource_group_location = "Central India"
  create_nsg              = true
  create_route_table      = false
  nsgs = [
    {
      name = "orx-aim-prod-agw-sn-nsg"
      rules = [
        {
          name                      = "AllowApplicationGatwayInBound"
          priority                  = 4095
          direction                 = "Inbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "65200-65535"
          source_address_prefix   = "GatewayManager"
          destination_address_prefix = "*"
        },
        {
          name                      = "AllowOptumInboundTraffic"
          priority                  = 4096
          direction                 = "Inbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "443"
          source_address_prefixes   = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23"]
          destination_address_prefix = "*"
        }
      ]
    },
    {
      name = "orx-aim-prod-ext-str-sn-nsg"
      rules = [
        {
          name                      = "AllowOptumInboundTraffic"
          priority                  = 4096
          direction                 = "Inbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "443"
          source_address_prefixes   = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23"]
          destination_address_prefix = "*"
        }
      ]
    },
    {
      name = "orx-aim-prod-int-str-sn-nsg"
      rules = []
    },
    {
      name = "orx-aim-prod-db-sn-nsg"
      rules = []
    },
    {
      name = "orx-aim-prod-pe-sn-nsg"
      rules = []
    },
    {
      name = "orx-aim-prod-con-sn-nsg"
      rules = [
        {
          name                      = "AllowOutboundContainerAppsControlPlaneTraffic"
          priority                  = 4090
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "5671-5672"
          source_address_prefix     = "*"
          destination_address_prefix = "*"
        },
        {
          name                      = "AllowOutboundNtpServerTraffic"
          priority                  = 4091
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Udp"
          source_port_range         = "*"
          destination_port_range   = "123"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                      = "AllowOutboundAzureMonitorTraffic"
          priority                  = 4093
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "443"
          source_address_prefix   = "*"
          destination_address_prefix = "AzureMonitor"
        },
        {
          name                      = "AllowOutboundAzureCloudUdpTraffic"
          priority                  = 1194
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Udp"
          source_port_range         = "*"
          destination_port_range    = "1194"
          source_address_prefix      = "*"
          destination_address_prefix = "AzureCloud.centralus"
        },
        {
          name                      = "AllowOutboundAzureCloudTcpTraffic"
          priority                  = 4094
          direction                 = "Outbound"
          access                    = "Allow"
          protocol                  = "Tcp"
          source_port_range         = "*"
          destination_port_range   = "9000"
          source_address_prefix    = "*"
          destination_address_prefix = "AzureCloud.centralus"
        }
      ]
    }
  ]
  subnets = {
    orx-aim-prod-agw-sn = {
      cidr                                           = "10.40.20.0/27"
      nsg_association                                = "orx-aim-prod-agw-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = false
      del_name                                       = ""
      service_delegation_name                        = ""
    },
    orx-aim-prod-ext-str-sn  = {
      cidr                                           = "10.40.20.32/27"
      nsg_association                                = "orx-aim-prod-ext-str-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = false
      del_name                                       = ""
      service_delegation_name                        = ""
    },
    orx-aim-prod-int-str-sn   = {
      cidr                                           = "10.40.20.64/27"
      nsg_association                                = "orx-aim-prod-int-str-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = false
      del_name                                       = ""
      service_delegation_name                        = ""
    },
    orx-aim-prod-db-sn   = {
      cidr                                           = "10.40.20.96/27"
      nsg_association                                = "orx-aim-prod-db-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = true
      del_name                                       = ""
      service_delegation_name                        = "Microsoft.DBforPostgreSQL/flexibleServers"
    },
    orx-aim-prod-pe-sn   = {
      cidr                                           = "10.40.20.128/27"
      nsg_association                                = "orx-aim-prod-pe-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = false
      del_name                                       = ""
      service_delegation_name                        = ""
    },
    orx-aim-prod-con-sn   = {
      cidr                                           = "10.40.22.0/23"
      nsg_association                                = "orx-aim-prod-con-sn-nsg"
      route_table                                    = ""
      enforce_private_link_endpoint_network_policies = false
      service_endpoint                               = true
      service_delegation                             = true
      del_name                                       = ""
      service_delegation_name                        = "Microsoft.App/environments"
    }
  }

  serviceendpoint = ["Microsoft.Storage","Microsoft.KeyVault","Microsoft.Web","Microsoft.Sql","Microsoft.ContainerRegistry", "Microsoft.ServiceBus"]
  environment     = "prod"
  ask_id          =  "AIDE_0078506"
  description     = ""
}
