module "network" {
	source = "git::https://github.com/cassio/cassio-vpc-custom.git?ref=v1.0.4"
	name = "cassio-vpc-cap10"
	project = "sound-yew-275622"
	description = "Rede do chapter 10"
}
