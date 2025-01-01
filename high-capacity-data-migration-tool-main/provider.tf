terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.31.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.2.1"
    }
  }
  required_version = ">= 1.0" 
}

# Configure the Linode Provider
provider "linode" {
   token = var.linode_token
}

provider "kubernetes" {
  host                   = local.kubeconfig_hcl.clusters[0].cluster.server
  token                  = local.kubeconfig_hcl.users[0].user.token
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl.clusters[0].cluster.certificate-authority-data)
}

provider "helm" {
  kubernetes {
    host                   = local.kubeconfig_hcl.clusters[0].cluster.server
    token                  = local.kubeconfig_hcl.users[0].user.token
    cluster_ca_certificate = base64decode(local.kubeconfig_hcl.clusters[0].cluster.certificate-authority-data)
  }
  # experiments {
  #   manifest = true
  # }
}

provider "kubectl" {
  host                   = local.kubeconfig_hcl.clusters[0].cluster.server
  cluster_ca_certificate = base64decode(local.kubeconfig_hcl.clusters[0].cluster.certificate-authority-data)
  token                  = local.kubeconfig_hcl.users[0].user.token
  load_config_file       = false
}

provider "htpasswd" {
}
