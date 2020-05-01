resource "google_compute_disk" "disk-cassio-ext01" {
	name  = "disk-cassio-ext01"
	type  = "pd-ssd"
	size  = 50
	zone  = "southamerica-east1-a"
	physical_block_size_bytes = 4096
}
