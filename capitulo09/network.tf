resource "google_compute_network" "vpc-cassio01" {
  name = "vpc-cassio01"
  auto_create_subnetworks = true
}
