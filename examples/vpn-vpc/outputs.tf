output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.vpc_id
}

output "private_subnet_id" {
  description = "The id of private subnet."
  value       = module.vpc.private_subnet_id
}

output "vpn_gateway_id" {
  description = "The id of route table entry."
  value       = module.vpc.vpn_gateway_id
}

output "vpn_gateway_public_ip_address" {
  description = "The id of route table entry."
  value       = module.vpc.vpn_gateway_public_ip_address
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}