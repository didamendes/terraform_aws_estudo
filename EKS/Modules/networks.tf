module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = format("%s-vpc", var.eks_name)
  cidr = "10.0.0.0/16"

  azs             = ["eu-east-1a", "eu-east-1b", "eu-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  private_subnet_tags = {
    "Name"                                  = format("%s-sub-private", var.eks_name),
    "kubernetes.io/role/internal-elb"       = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }

  public_subnet_tags = {
    "Name"                                  = format("%s-sub-public", var.eks_name),
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }

}