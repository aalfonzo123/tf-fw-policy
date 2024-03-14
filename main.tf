data "google_project" "current-project" {
}

module "vpc-1-fw-policy" {
  source  = "./content-fw-policy"
  network = var.network
}

module "vpc-2-fw-policy" {
  source  = "./content-fw-policy"
  network = var.network-2
}