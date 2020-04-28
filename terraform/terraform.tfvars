project_name          = "homelab-266501"
app_name              = "ingcognito"
gcp_credentials_path  = "./terraform-sa-keyfile.json"
region                = "us-central1"
zone                  = "us-central1-a"
private_subnet_cidr_1 = "10.10.1.0/24"

ssh_username     = "debian"
ssh_pub_key_path = "~/.ssh/ingcognito.pub"

image_name                   = "debian-cloud/debian-10"
swarm_managers_instance_type = "n1-standard-4"
managers_image_size          = 25
swarm_workers_instance_type  = "n1-standard-2"
workers_image_size           = 10
swarm_workers                = "1"

sql_instance_size          = "db-f1-micro"
sql_disk_type              = "PD_SSD"
sql_disk_size              = 10
sql_require_ssl            = true
sql_connect_retry_interval = 60
sql_master_zone            = "us-central1-a"
sql_replica_zone           = "us-central1-b"
sql_pass                   = "123"
sql_user                   = "123"

lb_static_ip		   = "34.107.216.54"
