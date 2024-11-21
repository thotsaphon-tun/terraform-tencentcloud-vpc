output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.vpc_id
}

output "private_subnet_id" {
  description = "The id of private subnet."
  value       = module.vpc.private_subnet_id
}