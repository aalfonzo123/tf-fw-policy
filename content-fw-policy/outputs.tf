output "content-fw-policy" {
    value = google_compute_network_firewall_policy.content-fw-policy
}

output "database-tag" {
    value = google_tags_tag_value.content-database
}

output "backend-tag" {
    value = google_tags_tag_value.content-backend
}