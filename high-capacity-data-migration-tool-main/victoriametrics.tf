resource "kubectl_manifest" "victoriametrics_vmsingle" {
    yaml_body = file("${path.module}/victoriametrics/VMSingle.yaml")
    depends_on = [helm_release.victoriametrics]
}

resource "kubectl_manifest" "victoriametrics_vmagent" {
    yaml_body = file("${path.module}/victoriametrics/VMAgent.yaml")
    depends_on = [helm_release.victoriametrics]
}

resource "kubectl_manifest" "victoriametrics_vmpodscrape" {
    yaml_body = file("${path.module}/victoriametrics/VMPodScrape.yaml")
    depends_on = [helm_release.victoriametrics]
}