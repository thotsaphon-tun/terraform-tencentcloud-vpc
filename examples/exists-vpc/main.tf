data "tencentcloud_vpc_instances" "foo" {
  name = "Default-VPC"
}

module "vpc" {
  source     = "../../"
  create_vpc = false
  vpc_id     = data.tencentcloud_vpc_instances.foo.instance_list.0.vpc_id

  private_subnets = ["172.16.64.0/20", "172.16.128.0/20"]

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
