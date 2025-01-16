resource "aws_eks_cluster" "main" {
  name = var.cluster_name

  role_arn = var.cluster_role_arn
  version = "1.31"

  vpc_config {
    subnet_ids = var.private_subnet_id
  }
}

resource "terraform_data" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ap-northeast-2 --name ${var.cluster_name}"
  }

  depends_on = [aws_eks_cluster.main]
}