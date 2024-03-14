variable "services" {
}

variable "network" {
  type = object({
    project-id = string
    vpc-name   = string
  })
}

variable "network-2" {
  type = object({
    project-id = string
    vpc-name   = string
  })
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