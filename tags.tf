data "google_project" "current-project" {
}

resource "google_tags_tag_key" "environment-tag" {
  parent      = data.google_project.current-project.id
  short_name  = "environment-tag"
  description = "Tag example"
  purpose     = "GCE_FIREWALL"
  purpose_data = {
    network = "${data.google_project.current-project.project_id}/${var.network}" #data.google_compute_network.vpc.self_link
  }
}

resource "google_tags_tag_value" "environment-dev" {
  parent      = "tagKeys/${google_tags_tag_key.environment-tag.name}"
  short_name  = "dev"
  description = "development"
}

resource "google_tags_tag_value" "environment-prod" {
  parent      = "tagKeys/${google_tags_tag_key.environment-tag.name}"
  short_name  = "prod"
  description = "production"
}

