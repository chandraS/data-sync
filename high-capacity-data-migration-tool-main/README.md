# High Capacity Data Migration Tool

## Overview
This repository contains Terraform code for deploying a high-capacity data migration solution using Linode Kubernetes Engine (LKE).

### Architecture Diagram
![image](https://bits.linode.com/storage/user/1648/files/c28ef2a9-b411-4db2-98f3-a7231fb51832)

## Prerequisites
- Terraform (version 1.5.0 or higher)
- Linode Account
- Linode API Token

## Configuration

### Step 1: Fill in Configuration Variables
Edit the `config.tfvars` file and replace the placeholders with your actual configuration:

```hcl
# Linode Account Token
linode_token = "<customer-linode-account-token>"

# Deployment Region
region = "<your-region-code>"

# Linode Object Storage Configuration
os_url = "es-mad-1.linodeobjects.com"  # Modify if needed
os_bucket = "<bucket-name>"
os_accesskey = "<your-access-key>"
os_secretkey = "<your-secret-key>"
```

### Configuration Variables Explanation

#### Linode Configuration
- `linode_token`: Your Linode API personal access token
- `region`: Linode region code where resources will be deployed (e.g., `es-mad`)

#### Object Storage Configuration
- `os_url`: Linode Object Storage endpoint URL
- `os_bucket`: Name of the bucket for storing logs and migration state
- `os_accesskey`: Object Storage access key
- `os_secretkey`: Object Storage secret key

#### Infrastructure Configuration (Advanced)
- `lke_mgmt_node_type`: Node type for management nodes
- `lke_worker_node_type`: Node type for worker nodes
- `lke_mgmt_node_count`: Number of management nodes
- `lke_worker_node_count`: Number of worker nodes
- `lke_version`: Kubernetes cluster version

## Deployment

### Initialize Terraform
```bash
terraform init
```

### Validate Configuration
```bash
terraform plan -var-file=config.tfvars
```

### Apply Configuration
```bash
terraform apply -var-file=config.tfvars
```

## Post-Deployment Access

### Dashboard URLs
After deployment, Terraform will output two dashboard URLs:
- Argo Workflow: `http://argo-workflow.<some-ip-address>.nip.io/`
- Grafana: `http://grafana.<some-ip-address>.nip.io/`

### Retrieving Dashboard Credentials

#### Accessing Grafana
1. Username: `admin`
2. Password: Retrieve from Kubernetes secret
   ```bash
   kubectl get secret grafana -n default -o jsonpath="{.data.admin-password}" | base64 --decode
   ```

#### Accessing Argo Workflow
1. Username: `admin`
2. Password: Retrieve from Kubernetes secret
   ```bash
   kubectl get secret credentials-argo-server -n argo-workflow -o jsonpath="{.data.admin}" | base64 --decode
   ```

# HTTP Data Migration Workflow Template (Edgio storage migration)

This document describes an Argo WorkflowTemplate designed to handle parallel data migration jobs using Rclone. The template allows for configurable parallel processing of file migrations between HTTP endpoints and Linode Object Storage.

## Parameters

The following parameters must be provided when submitting the workflow:

### `customer-name` (required)
- Type: string
- Description: A unique identifier (UUID) used to track the global migration job
- Example: `"customer-123-migration"`

### `rclone-conf` (required)
- Type: string
- Description: Rclone configuration file content following the standard Rclone configuration syntax
- Format: Standard Rclone config file format
- Example:
  ```ini
  [edgio-http]
  type = http
  url = https://<your-edgio-hostname.com>/  #<replace with your endpoint>

  [linode]
  type = s3
  provider = Ceph
  access_key_id = <your-access-key>
  secret_access_key = <your-secret-key>
  endpoint = <your-region>.linodeobjects.com
  acl = private
  ```

### `input-config-json` (required)
- Type: JSON array
- Description: Configuration for migration steps, defining source and destination details
- Format: Array of migration step objects

#### Migration Step Object Structure
```json
{
  "object_list_name": "list-of-files.txt",
  "object_list_path": "object-list-file/<customer-name>/list-of-files.txt",
  "rclone_source_name": "<rclone-remote-source>",
  "rclone_destination_name": "<rclone-remote-destination>",
  "rclone_destination_bucket": "<destination-bucket>",
  "parallel_sync_jobs": "N"
}
```

| Field | Description |
|-------|-------------|
| `object_list_name` | Name of the file containing the list of objects to migrate |
| `object_list_path` | Full path to the object list file |
| `rclone_source_name` | Name of the source remote in the Rclone config |
| `rclone_destination_name` | Name of the destination remote in the Rclone config |
| `rclone_destination_bucket` | Destination bucket name |
| `parallel_sync_jobs` | Number of parallel jobs to split the migration into |

## Multi-Job Configuration

The `input-config-json` array supports multiple migration configurations, allowing you to handle complex migration scenarios. Here's an example of a multi-job configuration:

```json
[
  {
    "object_list_name": "data1.txt",
    "object_list_path": "object-list-file/customer-123/data1.txt",
    "rclone_source_name": "edgio-source-1",
    "rclone_destination_name": "linode-destination",
    "rclone_destination_bucket": "primary-backup",
    "parallel_sync_jobs": "9"
  },
  {
    "object_list_name": "data2.txt",
    "object_list_path": "object-list-file/customer-123/data2.txt",
    "rclone_source_name": "edgio-source-1",
    "rclone_destination_name": "linode-destination",
    "rclone_destination_bucket": "secondary-backup",
    "parallel_sync_jobs": "5"
  },
  {
    "object_list_name": "large-files.txt",
    "object_list_path": "object-list-file/customer-123/large-files.txt",
    "rclone_source_name": "edgio-source-2",
    "rclone_destination_name": "linode-destination-2",
    "rclone_destination_bucket": "large-files-backup",
    "parallel_sync_jobs": "3"
  }
]
```

![image](https://bits.linode.com/storage/user/1648/files/30a3cb38-53c4-4e00-a86f-54a5b3729d6f)


### Use Cases for Multi-Job Configuration

1. **Different Performance Requirements**
   - Each object in the array can specify different `parallel_sync_jobs` values based on the nature of the files.

2. **Multiple Destinations**
   - You can migrate different sets of files to different storage systems:
     - Some files to NetStorage (`NS-destination`)
     - Others to Linode Object Storage (`linode-destination`)
     - Each destination can have its own configuration and optimization

3. **Custom Migration Strategies**
   - Each configuration object can represent a different migration strategy:
     - Different source paths
     - Different destination buckets
     - Different parallelization levels
