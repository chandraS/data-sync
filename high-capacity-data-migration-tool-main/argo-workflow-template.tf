resource "kubectl_manifest" "argo-workflow-template-http" {
    yaml_body = file("${path.module}/argo-workflow/workflowTemplate-http.yaml")
    depends_on = [helm_release.argo-workflow]
}