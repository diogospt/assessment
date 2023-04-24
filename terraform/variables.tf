variable "project_id" {
  description = "project id"
  type = string
  default = "infrastructure-384423"
}

variable "region" {
  default = "europe-west4"
  type = string
}

variable zone_a {
  default = "europe-west4-a"
  type = string
}

variable zone_b {
  default = "europe-west4-b"
  type = string
}

variable zone_c {
  default = "europe-west4-c"
  type = string
}

variable "vpc_subnetwork" {
  type = string
  default = "ew4-kubernetes"
}

variable "vpc_network" {
  type = string
  default = "kubernetes"
}