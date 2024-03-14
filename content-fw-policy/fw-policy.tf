resource "google_compute_network_firewall_policy" "content-fw-policy" {
  name        = "${var.network}-content-fw-policy"
  description = "Content firewall policy"
}

data "google_compute_network" "vpc" {
  name = var.network
}

resource "google_compute_network_firewall_policy_association" "fw-policy-vpc-association" {
  name              = "fw-policy-vpc-association"
  attachment_target = data.google_compute_network.vpc.id
  firewall_policy   = google_compute_network_firewall_policy.content-fw-policy.name
}

resource "google_compute_network_firewall_policy_rule" "backend-database-fw-policy-rule" {
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
