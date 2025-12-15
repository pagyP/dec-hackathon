variable "name_length" {
  description = "Number of words for the random name"
  type        = number
  default     = 2
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "dec"
}

variable "resource_group_name" {
  description = "Resource group name to create resources in"
  type        = string
  default     = "dec-hack-rg"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "uksouth"
}

variable "hub_vnet_cidr" {
  description = "Hub VNet CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_app_vnet_cidr" {
  description = "Spoke (app) VNet CIDR"
  type        = string
  default     = "10.1.0.0/16"
}

variable "spoke_onprem_vnet_cidr" {
  description = "Spoke (onprem) VNet CIDR"
  type        = string
  default     = "10.2.0.0/16"
}

variable "spoke_app_subnets" {
  description = "List of subnets for the app spoke VNet"
  type        = list(object({ name = string, address_prefix = string }))
  default = [
    { name = "app-subnet-1", address_prefix = "10.1.1.0/24" },
    { name = "app-subnet-2", address_prefix = "10.1.2.0/24" },
  ]
}

variable "spoke_onprem_subnets" {
  description = "List of subnets for the onprem spoke VNet"
  type        = list(object({ name = string, address_prefix = string }))
  default = [
    { name = "onprem-subnet-1", address_prefix = "10.2.1.0/24" },
    { name = "onprem-subnet-2", address_prefix = "10.2.2.0/24" },
  ]
}

variable "linux_ssh_public_key" {
  description = "Public SSH key for Linux VMs (optional). If empty, a password will be generated."
  type        = string
  default     = ""
}

variable "linux_admin_password" {
  description = "Admin password for Linux VM (sensitive). If empty, a random password will be generated."
  type        = string
  default     = ""
  sensitive   = true
}

variable "windows_admin_password" {
  description = "Admin password for Windows VM (sensitive). If empty, a random password will be generated."
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_vpn" {
  description = "Whether to deploy a VPN gateway and connection to simulate on-prem (can incur cost)"
  type        = bool
  default     = false
}

variable "gateway_subnet_cidr" {
  description = "CIDR for GatewaySubnet in hub if VPN is created"
  type        = string
  default     = "10.0.255.0/27"
}

variable "hub_subnets" {
  description = "List of subnets for the hub VNet (see modules/vnet for schema)"
  type = list(object({
    name              = string
    address_prefix    = string
    service_endpoints = optional(list(string))
  }))
  default = []
}

variable "azure_bastion_subnet" {
  description = "Subnet to create for Azure Bastion. Name should be 'AzureBastionSubnet' per Azure requirements."
  type        = object({ name = string, address_prefix = string })
  default     = { name = "AzureBastionSubnet", address_prefix = "10.0.3.0/27" }

  validation {
    condition     = var.azure_bastion_subnet.name == "AzureBastionSubnet"
    error_message = "The Azure Bastion subnet must be named 'AzureBastionSubnet'"
  }
}

variable "create_bastion" {
  description = "Whether to deploy Azure Bastion in the hub VNet (can incur cost)"
  type        = bool
  default     = false
}

variable "private_dns_resolver_subnets" {
  description = "Two subnets required for Azure Private DNS Resolver; provide a list of two subnet objects"
  
  default = [
    { 
      name = "AzurePrivateDnsResolverSubnet1"
      address_prefix = "10.0.5.0/28"
      service_endpoints = [],
      delegations = [
        {
          name = "dnsResolverDelegation"
          service_delegation_name = "Microsoft.Network/dnsResolvers"
        }
      ]
     },
    {
       name = "AzurePrivateDnsResolverSubnet2",
        address_prefix = "10.0.6.0/28"
        service_endpoints = []
        delegations = [
          {
            name = "dnsResolverDelegation"
            service_delegation_name = "Microsoft.Network/dnsResolvers"
          }
        ]
    }
  
  ]
  }


  


  # validation {
  #   condition     = length(var.private_dns_resolver_subnets) == 2
  #   error_message = "You must provide exactly two subnets for the Private DNS Resolver"
  # }
#}

# variable "subnets" {
#   description = "List of additional subnets to create in the VNet. Each item should be an object with 'name' and 'address_prefix' and optional 'service_endpoints'"
#   type = list(object({
#     name           = string
#     address_prefix = string
#     service_endpoints = optional(list(string))
#     # Optional delegations: list of objects with 'name' and 'service_delegation_name'
#     delegations = optional(list(object({
#       name = string
#       service_delegation_name = string
#     })))
#   }))
#   default = []
# }

variable "onprem_gateway_ip" {
  description = "Public IP of simulated on-prem VPN device (required if create_vpn=true)"
  type        = string
  default     = ""
}

variable "onprem_address_space" {
  description = "Address space announced by the simulated on-prem"
  type        = string
  default     = "192.168.100.0/24"
}

variable "vpn_sku" {
  description = "VPN gateway SKU"
  type        = string
  default     = "VpnGw1"
}

variable "vpn_shared_key" {
  description = "Pre-shared key for VPN connection (only when create_vpn=true)"
  type        = string
  default     = "changeme123!"
  sensitive   = true
}
