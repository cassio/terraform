resource "google_compute_attached_disk" "disk-cassio-ext01" {
  disk     = google_compute_disk.disk-cassio-ext01.id
  instance = google_compute_instance.vm0.id
}

resource "google_compute_instance" "vm0" {
  name         =  var.machine_name
  machine_type =  var.machine_type
  zone         = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.vpc-cassio01.self_link
    access_config {
    }
  }

depends_on = [
        google_compute_disk.disk-cassio-ext01
  ]

}
