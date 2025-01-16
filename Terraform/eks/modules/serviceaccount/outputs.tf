output "sa_name" {
  value = kubernetes_service_account.service_account.metadata[0].name
}