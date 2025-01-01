resource "kubernetes_secret" "obj-cred" {
  metadata {
    name = "obj-cred"
    namespace = "argo-workflow"
  }

  data = {
    accesskey = var.os_accesskey
    secretkey = var.os_secretkey
  }

  type = "Opaque"
  depends_on = [ helm_release.argo-workflow ]
}

resource "kubernetes_secret" "basic-auth-argo-server" {
  metadata {
    name = "basic-auth-argo-server"
    namespace = "argo-workflow"
  }

  data = {
    auth = "admin:${htpasswd_password.hash-password-argo.bcrypt}"
  }

  type = "Opaque"
  depends_on = [ helm_release.argo-workflow ]
}

resource "kubernetes_secret" "credentials-argo-server" {
  metadata {
    name = "credentials-argo-server"
    namespace = "argo-workflow"
  }

  data = {
    admin = random_password.password-argo.result
  }

  type = "Opaque"
  depends_on = [ helm_release.argo-workflow ]
}