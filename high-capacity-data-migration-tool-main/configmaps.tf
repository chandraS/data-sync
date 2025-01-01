resource "kubernetes_config_map" "artifact-repositories" {
  metadata {
    name = "artifact-repositories"
    namespace = "argo-workflow"
    annotations = {
      "workflows.argoproj.io/default-artifact-repository" = "default-v1-s3-artifact-repository"
    }
  }

  depends_on = [helm_release.argo-workflow]

  data = {
    "default-v1-s3-artifact-repository" = <<YAML
s3:
  bucket: ${var.os_bucket}
  endpoint: ${var.os_url}
  accessKeySecret:
    name: obj-cred
    key: accesskey
  secretKeySecret:
    name: obj-cred
    key: secretkey
YAML

  }
}
