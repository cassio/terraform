terraform {
	backend "gcs" {
	bucket = "gcs-cassio"
	prefix = "terraform/state"
	}
}
