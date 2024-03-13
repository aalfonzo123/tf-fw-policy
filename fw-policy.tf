resource "google_compute_network_firewall_policy" "fw-policy-sample" {
  name        = "fw-policy-sample"
  description = "Sample firewall policy"
}

data "google_compute_network" "vpc" {
  name = var.network
}

resource "google_compute_network_firewall_policy_association" "fw-policy-vpc-association" {
  name              = "fw-policy-vpc-association"
  attachment_target = data.google_compute_network.vpc.id
  firewall_policy   = google_compute_network_firewall_policy.fw-policy-sample.name
}

resource "google_compute_network_firewall_policy_rule" "fw-policy-rule" {
  action          = "allow"
  description     = "Allow prod to access dev on port 80"
  direction       = "INGRESS"
  firewall_policy = google_compute_network_firewall_policy.fw-policy-sample.name
  priority        = 1000
  rule_name       = "fw-policy-rule"
  target_secure_tags {
    name = google_tags_tag_value.environment-dev.id
  }

  match {
    src_secure_tags {
      name = google_tags_tag_value.environment-prod.id
    }
    layer4_configs {
      ip_protocol = "tcp"
      ports       = [80]
    }
  }
}
