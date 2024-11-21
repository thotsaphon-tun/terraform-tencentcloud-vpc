data "tencentcloud_availability_zones_by_product" "available_zones" {
  product = "cvm"
}

locals {
  len_public_subnets      = length(var.public_subnets)
  len_private_subnets     = length(var.private_subnets)
  len_database_subnets    = length(var.database_subnets)

  max_subnet_length = max(
    local.len_private_subnets,
    local.len_public_subnets,
    local.len_database_subnets,
  )

  vpc_id             = var.vpc_id == null ? tencentcloud_vpc.vpc[0].id : var.vpc_id
  create_vpc         = var.vpc_id == null ? var.create_vpc : false
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : data.tencentcloud_availability_zones_by_product.available_zones.zones.*.name
}

resource "tencentcloud_vpc" "vpc" {
  count        = local.create_vpc ? 1 : 0

  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  dns_servers  = length(var.vpc_dns_servers) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}

################################################################################
# Publiс Subnets
################################################################################

locals {
  create_public_subnets = local.create_vpc && local.len_public_subnets > 0
}

resource "tencentcloud_subnet" "public" {
  count             = local.create_public_subnets ? local.len_public_subnets : 0
  name              = format("%s_%s", var.public_subnet_name, format(var.number_format, count.index + 1))
  vpc_id            = local.vpc_id
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)
  is_multicast      = var.subnet_is_multicast
  availability_zone = element(local.availability_zones, count.index)
  tags              = merge(var.tags, var.public_subnet_tags)
}

locals {
  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
}

resource "tencentcloud_route_table" "public" {
  count = local.create_public_subnets ? local.num_public_route_tables : 0

  name   = var.create_multiple_public_route_tables ? format(
    "${var.vpc_name}-${var.public_subnet_suffix}-%s",
    element(local.availability_zones, count.index),
  ) : "${var.vpc_name}-${var.public_subnet_suffix}"
  vpc_id = local.vpc_id
  tags = merge(
    var.tags,
    var.public_route_table_tags
  )
}

resource "tencentcloud_route_table_association" "public" {
  count = local.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = element(tencentcloud_subnet.public[*].id, count.index)
  route_table_id = element(tencentcloud_route_table.public[*].id, var.create_multiple_public_route_tables ? count.index : 0)
}

################################################################################
# Public Network ACLs
################################################################################

resource "tencentcloud_vpc_acl" "public" {
  count = local.create_public_subnets && var.public_dedicated_network_acl ? 1 : 0

  name       = "${var.vpc_name}-${var.public_subnet_suffix}"
  vpc_id     = local.vpc_id
  ingress    = var.public_network_acl_ingress
  egress     = var.public_network_acl_egress

  tags = merge(
    var.tags,
    var.public_acl_tags,
  )
}

resource "tencentcloud_vpc_acl_attachment" "public" {
  count     = local.create_public_subnets && var.public_dedicated_network_acl ? local.len_public_subnets : 0
  acl_id    = tencentcloud_vpc_acl.public[0].id
  subnet_id = tencentcloud_subnet.public[count.index].id
}

################################################################################
# Private Subnets
################################################################################

locals {
  create_private_subnets = local.create_vpc && local.len_private_subnets > 0
}

resource "tencentcloud_subnet" "private" {
  count             = local.create_private_subnets ? local.len_private_subnets : 0
  name              = format("%s_%s", var.private_subnet_name, format(var.number_format, count.index + 1))
  vpc_id            = local.vpc_id
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)
  is_multicast      = var.subnet_is_multicast
  availability_zone = element(local.availability_zones, count.index)
  tags              = merge(var.tags, var.private_subnet_tags)
}

locals {
  num_private_route_tables = var.create_multiple_private_route_tables ? local.len_private_subnets : 1
}

resource "tencentcloud_route_table" "private" {
  count = local.create_private_subnets ? local.num_private_route_tables : 0

  name   = var.create_multiple_private_route_tables ? format(
    "${var.vpc_name}-${var.private_subnet_suffix}-%s",
    element(local.availability_zones, count.index),
  ) : "${var.vpc_name}-${var.private_subnet_suffix}"
  vpc_id = local.vpc_id
  tags = merge(
    var.tags,
    var.private_route_table_tags
  )
}

resource "tencentcloud_route_table_association" "private" {
  count = local.create_private_subnets ? local.len_private_subnets : 0

  subnet_id      = element(tencentcloud_subnet.private[*].id, count.index)
  route_table_id = element(tencentcloud_route_table.private[*].id, var.create_multiple_private_route_tables ? count.index : 0)
}

resource "tencentcloud_route_table_entry" "private_to_nat" {
  count = var.enable_nat_gateway ? local.num_private_route_tables : 0

  route_table_id         = element(tencentcloud_route_table.private[*].id, var.create_multiple_private_route_tables ? count.index : 0)
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = tencentcloud_nat_gateway.nat[0].id
}

################################################################################
# Private Network ACLs
################################################################################

resource "tencentcloud_vpc_acl" "private" {
  count = local.create_private_subnets && var.private_dedicated_network_acl ? 1 : 0

  name       = "${var.vpc_name}-${var.private_subnet_suffix}"
  vpc_id     = local.vpc_id
  ingress    = var.private_network_acl_ingress
  egress     = var.private_network_acl_egress

  tags = merge(
    var.tags,
    var.private_acl_tags,
  )
}

resource "tencentcloud_vpc_acl_attachment" "private" {
  count     = local.create_private_subnets && var.private_dedicated_network_acl ? local.len_private_subnets : 0
  acl_id    = tencentcloud_vpc_acl.private[0].id
  subnet_id = tencentcloud_subnet.private[count.index].id
}

################################################################################
# Database Subnets
################################################################################

locals {
  create_database_subnets = local.create_vpc && local.len_database_subnets > 0
}

resource "tencentcloud_subnet" "database" {
  count             = local.create_database_subnets ? local.len_database_subnets : 0
  name              = format("%s_%s", var.database_subnet_name, format(var.number_format, count.index + 1))
  vpc_id            = local.vpc_id
  cidr_block        = element(concat(var.database_subnets, [""]), count.index)
  is_multicast      = var.subnet_is_multicast
  availability_zone = element(local.availability_zones, count.index)
  tags              = merge(var.tags, var.database_subnet_tags)
}

locals {
  num_database_route_tables = var.create_multiple_database_route_tables ? local.len_database_subnets : 1
}

resource "tencentcloud_route_table" "database" {
  count = local.create_database_subnets ? local.num_database_route_tables : 0

  name   = var.create_multiple_database_route_tables ? format(
    "${var.vpc_name}-${var.database_subnet_suffix}-%s",
    element(local.availability_zones, count.index),
  ) : "${var.vpc_name}-${var.database_subnet_suffix}"
  vpc_id = local.vpc_id
  tags = merge(
    var.tags,
    var.database_route_table_tags
  )
}

resource "tencentcloud_route_table_association" "database" {
  count = local.create_database_subnets ? local.len_database_subnets : 0

  subnet_id      = element(tencentcloud_subnet.database[*].id, count.index)
  route_table_id = element(tencentcloud_route_table.database[*].id, var.create_multiple_database_route_tables ? count.index : 0)
}

################################################################################
# Database Network ACLs
################################################################################

resource "tencentcloud_vpc_acl" "database" {
  count = local.create_database_subnets && var.database_dedicated_network_acl ? 1 : 0

  name       = "${var.vpc_name}-${var.database_subnet_suffix}"
  vpc_id     = local.vpc_id
  ingress    = var.database_network_acl_ingress
  egress     = var.database_network_acl_egress

  tags = merge(
    var.tags,
    var.database_acl_tags,
  )
}

resource "tencentcloud_vpc_acl_attachment" "database" {
  count     = local.create_database_subnets && var.database_dedicated_network_acl ? local.len_database_subnets : 0
  acl_id    = tencentcloud_vpc_acl.database[0].id
  subnet_id = tencentcloud_subnet.database[count.index].id
}

################################################################################
# VPN Gateway
################################################################################
resource "tencentcloud_vpn_gateway" "vpn" {
  count          = var.enable_vpn_gateway ? 1 : 0
  name           = "${var.vpc_name}-vpngw"
  type           = var.vpn_gateway_type
  vpc_id         = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  bandwidth      = var.vpn_gateway_bandwidth
  max_connection = var.vpn_gateway_max_connection
  zone           = var.vpn_gateway_availability_zone != "" ? var.vpn_gateway_availability_zone : local.availability_zones[0]

  tags = merge(
    var.tags,
    var.vpn_gateway_tags,
  )
}

################################################################################
# NAT
################################################################################
resource "tencentcloud_eip" "nat_eip" {
  count = var.enable_nat_gateway && length(var.nat_public_ips) == 0 ? var.num_allocated_nat_ips : 0
  name  = "${var.vpc_name}-natip-${count.index}"
  tags = merge(
    var.tags,
    var.nat_gateway_tags
  )
}

resource "tencentcloud_nat_gateway" "nat" {
  count            = var.enable_nat_gateway ? 1 : 0
  name             = "${var.vpc_name}-nat"
  vpc_id           = local.vpc_id
  bandwidth        = var.nat_gateway_bandwidth
  max_concurrent   = var.nat_gateway_concurrent
  assigned_eip_set = length(var.nat_public_ips) > 0 ? var.nat_public_ips : tencentcloud_eip.nat_eip.*.public_ip

  tags = merge(
    var.tags,
    var.nat_gateway_tags
  )
}