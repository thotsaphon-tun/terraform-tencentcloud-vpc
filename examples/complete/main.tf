module "vpc" {
  source   = "../../"
  vpc_name = "complete-vpc"
  vpc_cidr = "10.0.0.0/16"

  enable_vpn_gateway = true

  public_subnets   = ["10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.6.0/24", "10.0.7.0/24"]

  enable_nat_gateway = true

  public_network_acl_ingress = ["ACCEPT#0.0.0.0/0#80#TCP", "ACCEPT#0.0.0.0/0#443#TCP", "ACCEPT#10.0.0.0/8#ALL#ALL"]
  public_network_acl_egress  = ["ACCEPT#0.0.0.0/0#ALL#ALL"]
  private_network_acl_ingress = ["ACCEPT#10.0.0.0/8#ALL#ALL"]
  private_network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#ALL"]
  database_network_acl_ingress = ["ACCEPT#10.0.0.0/8#3306#TCP"]
  database_network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#TCP"]

  tags = {
    "module" = "vpc"
  }
}