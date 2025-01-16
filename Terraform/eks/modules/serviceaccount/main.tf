resource "kubernetes_service_account" "service_account" {
  metadata {
    name = var.sa_name
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/cluster" = var.cluster_name
      "app.kubernetes.io/name"= var.sa_name
      "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.sa_role_arn
    }
  }
}