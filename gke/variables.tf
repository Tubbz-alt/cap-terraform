variable "cluster_name" {
    type = string
}

variable "location" {
    default = "us-central1-a"
}

variable "project" {
    type = string
}

variable "node_pool_name" {
    type = string
}

variable "instance_count" {
    default = "3"
}
variable "node_count" {
  default = "3"
}

variable "preemptible" {
    type = bool
    default = false
}

variable "instance_type" {
    default = "n1-standard-4"
}

variable "vm_type" {
    type = string
}

variable "cluster_labels" {
    type = map
}

variable "disk_size_gb" {
    default = 60
}

variable "gke_sa_key" {
    type = string
}

variable "gcp_dns_sa_key" {
    type = string
}

variable "k8s_version" {
    type = string
}
