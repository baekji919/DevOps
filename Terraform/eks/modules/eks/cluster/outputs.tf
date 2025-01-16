output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_url" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "oidc_url_without_https" {
  value = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}

output "name" {
  value = aws_eks_cluster.main.name
}