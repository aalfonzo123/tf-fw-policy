data "google_project" "project" {
  project_id = var.network.project-id
}

data "google_compute_network" "network" {
  name    = var.network.vpc-name
  project = var.network.project-id
}

resource "google_compute_network_firewall_policy" "content-fw-policy" {
  project     = data.google_project.project.id
  name        = "${var.network.vpc-name}-content-fw-policy"
  description = "Content firewall policy"
}

resource "google_compute_network_firewall_policy_association" "fw-policy-vpc-association" {
  name              = "fw-policy-vpc-association"
  attachment_target = data.google_compute_network.network.id
  firewall_policy   = google_compute_network_firewall_policy.content-fw-policy.name
  project           = data.google_project.project.id
}

resource "google_compute_network_firewall_policy_rule" "backend-database-fw-policy-rule" {
  project         = data.google_project.project.id
  action          = "allow"
  description     = "Allow backends to access databases on port 3306"
  direction       = "INGRESS"
  firewall_policy = google_compute_network_firewall_policy.content-fw-policy.name
  priority        = 1000
  rule_name       = "backend-database-fw-policy-rule"
  target_secure_tags {
    name = google_tags_tag_value.content-database.id
  }

  match {
    src_secure_tags {
      name = google_tags_tag_value.content-backend.id
    }
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [3306]
    }
  }
}
