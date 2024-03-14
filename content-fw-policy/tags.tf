data "google_project" "current-project" {
}

resource "google_tags_tag_key" "content-tag" {
  parent      = data.google_project.current-project.id
  short_name  = "${var.network}-content-tag"
  description = "Tag example"
  purpose     = "GCE_FIREWALL"
  purpose_data = {
    network = "${data.google_project.current-project.project_id}/${var.network}"
  }
}

resource "google_tags_tag_value" "content-database" {
  parent      = "tagKeys/${google_tags_tag_key.content-tag.name}"
  short_name  = "database"
  description = "database content"
}

resource "google_tags_tag_value" "content-backend" {
  parent      = "tagKeys/${google_tags_tag_key.content-tag.name}"
  short_name  = "backend"
  description = "backend content"
}