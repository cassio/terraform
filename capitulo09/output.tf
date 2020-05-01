output instance_id {
	value = google_compute_instance.vm0.instance_id
	description = "O identificador unico ID da instancia criada"
}
output network_external {
	value = google_compute_instance.vm0.network_interface.0.access_config.0.nat_ip
	description = "IP Externo"
}
