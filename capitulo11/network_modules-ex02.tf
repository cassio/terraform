module "modulo-tf-chapter11-ex2" {
	source = "terraform-google-modules/network/google"
	version = "2.0.1"

	network_name = "rede-tf-chapter11-ex2"
	project_id = "sound-yew-275622"
		
	subnets = [
		{
		subnet_name = "subnet-tf-chapter11-ex2"
		subnet_ip = "10.10.10.0/23"
		subnet_region = "us-west1"
		}
	]
}

output "subnets_ips" {
	value = module.modulo-tf-chapter11-ex2.subnets_ips
}

output "network_self_link" {
        value = module.modulo-tf-chapter11-ex2.network_self_link
}

output "subnets_regions" {
        value = module.modulo-tf-chapter11-ex2.subnets_regions
}

output "subnets_names" {
        value = module.modulo-tf-chapter11-ex2.subnets_names
}
