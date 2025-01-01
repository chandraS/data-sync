resource "helm_release" "victoriametrics" {
  name       = "victoria-metrics"

  repository = "https://victoriametrics.github.io/helm-charts/"
  chart      = "victoria-metrics-operator"

  set {
    name  = "nodeSelector.system-node"
    value = "true"
    type = "string"
  }
  
  version = "0.33.6"
}

resource "helm_release" "nginx_ingress_controller" {
  name       = "nginx-ingress-controller"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.nodeSelector.system-node"
    value = "true"
    type = "string"
  }
  set {
    name  = "defaultBackend.nodeSelector.system-node"
    value = "true"
    type = "string"
  }

}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  values = [
    file("./helm/grafana.yaml")
  ]
  set {
    name  = "nodeSelector.system-node"
    value = "true"
    type = "string"
  }
  set {
    name  = "datasources\\.datasources\\.yaml\\.datasources\\.secureJsonData\\.password"
    value = random_password.password.result
  }

}


resource "helm_release" "argo-workflow" {
  name       = "argo-workflow"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"
  namespace = "argo-workflow"
  create_namespace = true


  values = [
    file("./helm/argo-workflow.yaml")
  ]

}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  depends_on = [helm_release.nginx_ingress_controller]

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "nodeSelector.system-node"
    value = "true"
    type = "string"
  }
  set {
    name  = "cainjector.nodeSelector.system-node"
    value = "true"
    type = "string"
  }
  set {
    name  = "webhook.nodeSelector.system-node"
    value = "true"
    type = "string"
  }
}

resource "helm_release" "firewall_controller_crds" {
  name       = "firewall-controller-crds"
  repository = "https://linode.github.io/cloud-firewall-controller"
  chart      = "cloud-firewall-crd"

}

resource "helm_release" "firewall_controller" {
  name       = "firewall-controller"
  repository = "https://linode.github.io/cloud-firewall-controller"
  chart      = "cloud-firewall-controller"
  depends_on = [ helm_release.firewall_controller_crds ]

}
