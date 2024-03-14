resource "google_service_account" "sa_virtual" {
  account_id   = "sa-virtual"
  display_name = "service account for test vm"
  project      = data.google_project.current-project.project_id
  depends_on   = [google_project_service.services]
}

resource "google_project_iam_member" "sa_iam" {
  for_each = toset(var.roles)

  role    = each.value
  project = data.google_project.current-project.project_id
  member  = "serviceAccount:${google_service_account.sa_virtual.email}"
}

resource "google_compute_instance" "my-instance" {
  name                      = "my-instance"
  machine_type              = "e2-standard-2"
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      size  = "30"
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  scheduling {
    provisioning_model          = "SPOT"
    preemptible                 = true
    automatic_restart           = false
    instance_termination_action = "STOP"
  }

  service_account {
    email  = google_service_account.sa_virtual.email
    scopes = ["cloud-platform"]

  }

  lifecycle {
    ignore_changes = [metadata["ssh-keys"]]
  }
}

resource "google_tags_location_tag_binding" "binding" {
  parent    = "//compute.googleapis.com/projects/${data.google_project.current-project.number}/zones/${google_compute_instance.my-instance.zone}/instances/${google_compute_instance.my-instance.instance_id}"
  tag_value = module.vpc-1-fw-policy.database-tag.id
  location  = google_compute_instance.my-instance.zone
}