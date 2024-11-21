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

  vpn_gateway_tags = {
    test = "vpn"
  }

  enable_vpn_gateway = true
}
