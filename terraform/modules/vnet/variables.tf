variable "name" {
  description = "VNet name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "address_space" {
  description = "VNet CIDR"
  type        = string
}

variable "create_gateway_subnet" {
  description = "Whether to create a GatewaySubnet in this VNet"
  type        = bool
  default     = false
}

variable "gateway_subnet_cidr" {
  description = "CIDR for GatewaySubnet (if created)"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "List of additional subnets to create in the VNet. Each item should be an object with 'name' and 'address_prefix' and optional 'service_endpoints'"
  type = list(object({
    name           = string
    address_prefix = string
    service_endpoints = optional(list(string))
  }))
  default = []
}
