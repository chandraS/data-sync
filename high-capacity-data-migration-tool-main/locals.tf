locals {
  kubeconfig_yaml = base64decode(linode_lke_cluster.akamai-sync-argo-worflow.kubeconfig)
  kubeconfig_hcl  = yamldecode(local.kubeconfig_yaml)
  workerpool      = linode_lke_cluster.akamai-sync-argo-worflow.pool[1].id
  ingress_ip = data.kubernetes_service.ingress_svc.status.0.load_balancer.0.ingress[0].ip
}