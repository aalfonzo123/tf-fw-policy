variable "services" {
}

variable "network" {
}

variable "subnetwork" {
}

variable "roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
}

variable "zone" {

}

variable "region" {

}