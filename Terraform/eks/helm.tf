resource "helm_release" "alb_controller" {
  depends_on = [module.eks_cluster, module.private_subnet, module.eks_ng_staging, module.sa_alc]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name = "clusterName"
    value = "test"
  }

  set {
    name = "region"
    value = "ap-northeast-2"
  }

  set {
    name = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name = "serviceAccount.create"
    value = "false"
  }

  set {
    name = "serviceAccount.name"
    value = module.sa_alc.sa_name
  }

}