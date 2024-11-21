variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The vpc id used to launch resources."
  default     = null
}

variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default     = "172.16.0.0/16"
}

variable "vpc_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "vpc_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}


variable "subnet_is_multicast" {
  description = "Specify the subnet is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of available zones to launch resources."
  type        = list(string)
  default     = []
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = {}
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}

variable "route_table_tags" {
  description = "Additional tags for the route table."
  type        = map(string)
  default     = {}
}

################################################################################
# Publiс Subnets
################################################################################
variable "public_subnet_name" {
  description = "Specify the public subnet name when 'vpc_id' is not specified."
  default     = "public"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_multiple_public_route_tables" {
  description = "Indicates whether to create a separate route table for each public subnet. Default: `false`"
  type        = bool
  default     = false
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# Public Network ACLs
################################################################################

variable "public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  type        = bool
  default     = false
}

variable "public_network_acl_ingress" {
  description = "Public subnets inbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = null
}

variable "public_network_acl_egress" {
  description = "Public subnets outbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

variable "public_acl_tags" {
  description = "Additional tags for the public subnets network ACL"
  type        = map(string)
  default     = {}
}


################################################################################
# Private Subnets
################################################################################

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_multiple_private_route_tables" {
  description = "Indicates whether to create a separate route table for each private subnet. Default: `false`"
  type        = bool
  default     = false
}

variable "private_subnet_name" {
  description = "Specify the private subnet name when 'vpc_id' is not specified."
  default     = "private"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# Private Network ACLs
################################################################################

variable "private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  type        = bool
  default     = false
}

variable "private_network_acl_ingress" {
  description = "Private subnets inbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = null
}

variable "private_network_acl_egress" {
  description = "Private subnets outbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

variable "private_acl_tags" {
  description = "Additional tags for the private subnets network ACL"
  type        = map(string)
  default     = {}
}


################################################################################
# Database Subnets
################################################################################

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "create_multiple_database_route_tables" {
  description = "Indicates whether to create a separate route table for each database subnet. Default: `false`"
  type        = bool
  default     = false
}

variable "database_subnet_name" {
  description = "Specify the database subnet name when 'vpc_id' is not specified."
  default     = "database"
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  type        = string
  default     = "database"
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
}

variable "database_route_table_tags" {
  description = "Additional tags for the database route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# Database Network ACLs
################################################################################

variable "database_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets"
  type        = bool
  default     = false
}

variable "database_network_acl_ingress" {
  description = "Database subnets inbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = null
}

variable "database_network_acl_egress" {
  description = "Database subnets outbound network ACLs, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`"
  type        = list(string)
  default     = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}

variable "database_acl_tags" {
  description = "Additional tags for the database subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# VPN Gateway
################################################################################
variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "vpn_gateway_bandwidth" {
  description = "bandwidth of VPN Gateway"
  type        = number
  default     = 5
}

variable "vpn_gateway_max_connection" {
  description = " Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways."
  type        = number
  default     = 5
}

variable "vpn_gateway_type" {
  description = "Type of VPN gateway. Valid value: IPSEC, SSL and CCN."
  type        = string
  default     = "IPSEC"
}

variable "vpn_gateway_availability_zone" {
  description = "The Availability Zone for the VPN Gateway"
  type        = string
  default     = ""
}

variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway
################################################################################

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "num_allocated_nat_ips" {
  description = "number of allocated NAT IPs in case `nat_public_ips` is not specifies."
  type        = number
  default     = 1
}

variable "nat_gateway_bandwidth" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 100
}

variable "nat_gateway_concurrent" {
  description = "bandwidth of NAT Gateway"
  type        = number
  default     = 1000000
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateway"
  type        = map(string)
  default     = {}
}

variable "nat_public_ips" {
  description = "List of EIPs to be used for `nat_gateway`"
  type        = list(string)
  default     = []
}