module "vpc" {
  source                           = "terraform-aws-modules/vpc/aws"
  version                          = "~> 1.66.0"
  name                             = "${var.name}"
  cidr                             = "${var.vpc_cidr}"
  azs                              = "${var.azs}"
  private_subnets                  = "${var.private_subnets}"
  public_subnets                   = "${var.public_subnets}"
  database_subnets                 = "${var.database_subnets}"
  enable_nat_gateway               = true
  single_nat_gateway               = true
  enable_vpn_gateway               = false
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.name}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${module.vpc.vpc_id}"
  tags = {
    Name = "${var.name}-public*"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${module.vpc.vpc_id}"

  tags = {
    Name = "${var.name}-private*"
  }
}