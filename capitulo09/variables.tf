variable "machine_type" {
	type = string
	default = "n1-standard-1"
	description = "Machine Type on GCP Default"
}

variable "machine_name" {
        type = string
        default = "vm-cassio"
        description = "Machine Name Default"
}
