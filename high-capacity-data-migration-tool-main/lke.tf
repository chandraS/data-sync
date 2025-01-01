resource "linode_lke_cluster" "akamai-sync-argo-worflow" {
    label       = "Akamai-Data-Sync-argo-worflow"
    k8s_version = var.lke_version
    region      = var.region
    tags        = ["app:datasync-argo-worflow"]
    
    control_plane {
      high_availability = true
    }
    
    pool {
        type  = var.lke_mgmt_node_type
        count = var.lke_mgmt_node_count
        labels = {
        "system-node" = "true"
      }
    }

    pool {
        type  = var.lke_worker_node_type
        count = var.lke_worker_node_count
        labels = {
          "rclone" = "true"
        }

      autoscaler {
          min = 1
          max = 15
        }        
    }

  # Prevent the count field from overriding autoscaler-created nodes
  lifecycle {
    ignore_changes = [
      pool[1].count
    ]
  }
}
