module "vpc" {
  source             = "../../"
  vpc_name           = "simple-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-guangzhou-7", "ap-guangzhou-6"]

  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }

  network_acl_tags = {
    test = "acl"
  }

  private_network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#TCP", "ACCEPT#9.0.0.0/8#ALL#TCP"]
  private_network_acl_ingress = ["ACCEPT#10.0.0.0/8#ALL#TCP"]
}
