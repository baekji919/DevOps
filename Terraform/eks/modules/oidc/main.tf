resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list = ["sts.amazonaws.com"]
  url = var.oidc_url

  thumbprint_list = ["thumbprint"]
}