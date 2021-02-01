variable "project_name" {}

variable "az_list" {
  type = list(string)
}

variable "az_list_node" {
  type = list(string)
}

variable "number_of_managers" {}

variable "number_of_workers" {}

variable "worker_root_volume_size_in_gb" {}

variable "public_key_path" {}

variable "image" {}

variable "ssh_user" {}

variable "flavor" {}

variable "network_name" {}

variable "network_id" {
  default = ""
}
variable "manager_ips" {
  type = list
}

variable "worker_ips" {
  type = list
}

variable "allowed_remote_ips" {
  type = list
}

variable "allowed_egress_ips" {
  type = list
}

variable "wait_for_floatingip" {}

variable "worker_allowed_ports" {
  type = list
}
