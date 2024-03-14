variable "network" {
  type = object({
    project-id = string
    vpc-name   = string
  })
}
