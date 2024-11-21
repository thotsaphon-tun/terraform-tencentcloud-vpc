output "vpc_id" {
  description = "The id of vpc."
  value       = var.vpc_id != "" ? var.vpc_id : concat(tencentcloud_vpc.vpc.*.id, [""])[0]
}

output "public_subnet_id" {
  description = "The id of public subnet."
  value       = tencentcloud_subnet.public.*.id
}

output "private_subnet_id" {
  description = "The id of private subnet."
  value       = tencentcloud_subnet.private.*.id
}

output "database_subnet_id" {
  description = "The id of database subnet."
  value       = tencentcloud_subnet.database.*.id
}

output "public_route_table_id" {
  description = "The id of public route table."
  value       = tencentcloud_route_table.public.*.id
}

output "private_route_table_id" {
  description = "The id of private route table."
  value       = tencentcloud_route_table.private.*.id
}

output "database_route_table_id" {
  description = "The id of database route table."
  value       = tencentcloud_route_table.database.*.id
}

output "availability_zones" {
  description = "The availability zones of instance type."
  value       = local.availability_zones
}

output "tags" {
  description = "A map of tags to add to all resources."
  value       = var.tags
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = try(tencentcloud_vpn_gateway.vpn[0].id, "")
}

output "vpn_gateway_public_ip_address" {
  description = "The public ip address of the VPN Gateway"
  value       = try(tencentcloud_vpn_gateway.vpn[0].public_ip_address, "")
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = try(tencentcloud_nat_gateway.nat[0].id, "")
}

output "nat_public_ips" {
  description = "The EIPs of the NAT Gateway"
  value       = length(var.nat_public_ips) > 0 ? var.nat_public_ips : tencentcloud_eip.nat_eip.*.public_ip
}