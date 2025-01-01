variable "linode_token" {
  default = ""
  type = string
  sensitive   = true
}

variable "lke_mgmt_node_type" {
  description = "Instance type for management nodes LKE pool"
  default = "g6-standard-1"
  type = string
}

variable "lke_worker_node_type" {
  description = "Instance type for worker nodes LKE pool"
  default = "g6-standard-1"
  type = string
}


variable "lke_mgmt_node_count" {
  description = "Number of nodes in management pool"
  default     = 3
  type        = number
}

variable "lke_worker_node_count" {
  description = "Number of nodes in worker pool"
  default     = 1
  type        = number
}

variable "lke_version" {
  description = "Kubernetes version"
  default     = 1.27
  type        = number
}

variable "os_url" {
  description = "Object Storage Cluster URL (without the bucket name)"
  default = ""
  type = string
}

variable "os_bucket" {
  description = "Object Storage Bucket name"
  default = ""
  type = string
}

variable "os_accesskey" {
  description = "Object Storage Access Key"
  default = ""
  type = string
  sensitive   = true
}

variable "os_secretkey" {
  description = "Object Storage Secret Key"
  default = ""
  type = string
  sensitive   = true
}

variable "region" {
  description = "Default region to use"
  default = ""
  type = string
}
