resource "kubectl_manifest" "ingress" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
spec:
  tls:
  - hosts:
    - grafana.${local.ingress_ip}.nip.io
    secretName: grafana-ingress-cert
  rules:
  - host: grafana.${local.ingress_ip}.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: grafana
            port: 
              number: 80 # Replace with the actual Grafana service port
YAML

  depends_on = [ kubectl_manifest.self_signed_issuer ]
}

resource "kubectl_manifest" "ingress-2" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argo-ingress
  namespace: argo-workflow
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth-argo-server
    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required'
    cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
spec:
  tls:
  - hosts:
    - argo-workflow.${local.ingress_ip}.nip.io
    secretName: argo-workflow-ingress-cert
  rules:
  - host: argo-workflow.${local.ingress_ip}.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argo-workflow-argo-workflows-server
            port: 
              number: 2746
YAML

  depends_on = [ kubectl_manifest.self_signed_issuer ]
}

resource "kubectl_manifest" "self_signed_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
YAML

  depends_on = [ helm_release.cert-manager ]
}

