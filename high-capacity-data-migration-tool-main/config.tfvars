#Akamai Connected Cloud configuration
linode_token = "<customer-linode-account-token>"
region = "<your-region-code>"

#################
# State Storage #
#################
#Linode Object Storage used for storage logs and state of the tool
os_url = "es-mad-1.linodeobjects.com"  #Modify if needed
os_bucket = "<bucket-name>"
os_accesskey = "<your-access-key>"
os_secretkey = "<your-secret-key>"

#Infrastructure configuration. Usually no need to change these stuff unless you know what you're doing. 
lke_mgmt_node_type = "g6-standard-2"
lke_worker_node_type = "g6-dedicated-8"
lke_mgmt_node_count = "3"
lke_worker_node_count = "1"
lke_version = "1.31"
