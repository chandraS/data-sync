output "grafana_ingress" {

  value = "https://grafana.${data.kubernetes_service.ingress_svc.status.0.load_balancer.0.ingress[0].ip}.nip.io/"
}

output "argo_workflow_ingress" {

  value = "https://argo-workflow.${data.kubernetes_service.ingress_svc.status.0.load_balancer.0.ingress[0].ip}.nip.io/"
}
