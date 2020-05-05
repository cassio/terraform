module "modulo-tf-chapter11" {
	source = "terraform-google-modules/network/google"
	version = "2.0.1"

	network_name = "rede-tf-chapter11"
	project_id = "sound-yew-275622"
	routing_mode = "REGIONAL"
		
	subnets = [
		{
		subnet_name = "subnet-tf-chapter11"
		subnet_ip = "192.168.0.0/16"
		subnet_region = "us-central1"
		}
	]
}

output "network_name" {
	value = module.modulo-tf-chapter11.network_name
}

output "network_self_link" {
        value = module.modulo-tf-chapter11.network_self_link
}

output "project_id" {
        value = module.modulo-tf-chapter11.project_id
}
