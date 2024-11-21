module "vpc" {
  source = "../../"

  vpc_name = "simple-vpc"
  vpc_cidr = "10.0.0.0/16"

  private_subnets = ["10.0.0.0/24"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }

  subnet_tags = {
    test = "subnet"
  }
}
