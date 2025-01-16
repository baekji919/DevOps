provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  config_path = "~/.kube/config"

  host = module.eks_cluster.endpoint
  token = data.aws_eks_cluster_auth.bstore.token
  #  cluster_ca_certificate = base64encode(module.eks_cluster.kubeconfig-certificate-authority-data)
}

data "aws_eks_cluster_auth" "bstore" {
  name = module.eks_cluster.name
  depends_on = [module.eks_cluster]
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"

    host = module.eks_cluster.endpoint
    token = data.aws_eks_cluster_auth.bstore.token
    #    cluster_ca_certificate = base64encode(module.eks_cluster.kubeconfig-certificate-authority-data)
  }
}

locals {
  account_id = "xxxxx"
  name = "test-v1"
  public_subnets = ["10.1.0.0/24", "10.1.32.0/24", "10.1.64.0/24"]
  private_subnets = ["10.1.96.0/24", "10.1.128.0/24", "10.1.160.0/24"]
  azs = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name = local.name
}

module "public_subnet" {
  source = "./modules/public_subnet"

  vpc_id = module.vpc.vpc_id
  vpc_name = local.name
  sub_cidr = local.public_subnets
  az = local.azs
  igw_id = module.gateway.igw_id
  vpc_peering_id = module.vpc_peering.id
  cluster_name = local.name
}

module "private_subnet" {
  source = "./modules/private_subnet"

  vpc_id = module.vpc.vpc_id
  vpc_name = local.name
  sub_cidr = local.private_subnets
  az = local.azs
  ngw_id = module.gateway.ngw_id
  vpc_peering_id = module.vpc_peering.id
  cluster_name = local.name
}

module "gateway" {
  source = "./modules/gateway"

  vpc_id = module.vpc.vpc_id
  igw_name = "${local.name}-igw"
  eip_name = "${local.name}-cluster/NATIP"
  ngw_name = "${local.name}-ngw"
  pub_subnet_id = module.public_subnet.pub_subnet_id
}

module "vpc_peering" {
  source = "./modules/peering"

  account_id = local.account_id
  default_vpc_id = "vpc-xxxxx"
  vpc_id = module.vpc.vpc_id
  vpc_name = local.name
  sub_rt_id = module.public_subnet.rt_id
}

######create cluster#######

module "eks_cluster" {
  source = "./modules/eks/cluster"

  cluster_name = local.name
  cluster_role_arn = module.eks_role.arn
  private_subnet_id = module.private_subnet.private_subnet_id
}

module "eks_role" {
  source = "./modules/eks/role/eks"

  cluster_name = local.name
}

#########NodeGroup#########

module "eks_test" {
  source = "./modules/eks/nodegroup"

  cluster_name = local.name
  ng_name = "${local.name}-test"
  node_role_arn = module.node_role.arn
  subnet_id = module.private_subnet.private_subnet_id

  desired_size = 1
  max_size = 2
  min_size = 1

  depends_on = [module.eks_cluster]
}

module "node_role" {
  source = "./modules/eks/role/node"

  cluster_name = local.name
}

#########AWS LoadBalancer Controller##########

module "oidc" {
  source = "./modules/oidc"

  oidc_url = module.eks_cluster.oidc_url
  depends_on = [module.eks_cluster]
}

module "sa_role" {
  source = "./modules/eks/role/alc"

  oidc_arn = module.oidc.oidc_arn
  oidc_url_without_https = module.eks_cluster.oidc_url_without_https
  sa_name = "test-aws-loadbalancer-controller"
}

module "sa_alc" {
  source = "./modules/serviceaccount"

  sa_name = "test-aws-loadbalancer-controller"
  cluster_name = local.name
  sa_role_arn = module.sa_role.arn
}

########VPC Link########

module "vpc_link" {
  source = "./modules/apigw/vpc_link"

  vpc_name = local.name
  vpc_security_group_id = [module.vpc.vpc_default_sg_id]
  subnet_id = module.private_subnet.private_subnet_id
}