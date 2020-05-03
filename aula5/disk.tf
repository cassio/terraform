resource "google_compute_disk" "default" {
  name  = "disk-cassio-0"
  type  = "pd-ssd"
  zone  = "southamerica-east1-a"
  physical_block_size_bytes = 4096
}
