project_name          = "homelab-266501"
app_name              = "ingcognito"
gcp_credentials_path  = "./terraform-sa-keyfile.json"
region                = "northamerica-northeast1"
zone                  = "northamerica-northeast1-a"
private_subnet_cidr_1 = "10.10.1.0/24"

ssh_username     = "debian"
ssh_pub_key_path = "~/.ssh/ingcognito.pub"

image_name                   = "debian-cloud/debian-10"
swarm_managers_instance_type = "n1-standard-2"
managers_image_size          = 25
swarm_workers_instance_type  = "n1-standard-1"
workers_image_size           = 10
swarm_workers                = "0"

lb_static_ip = "34.107.157.79"
