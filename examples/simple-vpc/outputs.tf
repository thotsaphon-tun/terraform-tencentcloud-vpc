output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The id of subnet."
  value       = module.vpc.public_subnet_id
}
