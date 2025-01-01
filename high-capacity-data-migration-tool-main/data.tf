resource "random_password" "password" {
  length           = 16
  special          = false
}

resource "random_password" "password-argo" {
  length           = 16
  special          = false
}

resource "random_password" "salt" {
  length           = 8
  special          = false
}

resource "htpasswd_password" "hash-password-argo" {
  password = random_password.password-argo.result
  salt     = random_password.salt.result
}

data "kubernetes_service" "ingress_svc" {
  metadata {
    name = "nginx-ingress-controller-ingress-nginx-controller"
  }

  depends_on = [ helm_release.nginx_ingress_controller ]
}
