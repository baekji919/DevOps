resource "aws_eks_node_group" "example" {
  cluster_name = var.cluster_name
  node_group_name = var.ng_name
  node_role_arn = var.node_role_arn
  subnet_ids = var.subnet_id

  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
}