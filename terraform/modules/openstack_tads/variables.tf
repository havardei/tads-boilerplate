variable "project_name" {
  default = "example"
}

variable "az_list" {
  description = "List of Availability Zones to use for masters in your OpenStack cluster"
  type        = list(string)
  default     = ["nova"]
}

variable "az_list_node" {
  description = "List of Availability Zones to use for nodes in your OpenStack cluster"
  type        = list(string)
  default     = ["nova"]
}

variable "number_of_managers" {
  default = 1
}
variable "number_of_workers" {
  default = 1
}
variable "worker_root_volume_size_in_gb" {
  default = 0
}

variable "public_key_path" {
  description = "The path of the ssh pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "image" {
  description = "the image to use"
  default     = ""
}

variable "ssh_user" {
  description = "used to fill out tags for ansible inventory"
  default     = "ubuntu"
}

variable "flavor" {
  description = "Use 'openstack flavor list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "network_name" {
  description = "name of the internal network to use"
  default     = "internal"
}

variable "use_neutron" {
  description = "Use neutron"
  default     = 1
}

variable "subnet_cidr" {
  description = "Subnet CIDR block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "floatingip_pool" {
  description = "name of the floating ip pool to use"
  default     = "external"
}

variable "wait_for_floatingip" {
  description = "Terraform will poll the instance until the floating IP has been associated."
  default     = "false"
}

variable "external_net" {
  description = "uuid of the external/public network"
}

variable "allowed_remote_ips" {
  description = "An array of CIDRs allowed to SSH to hosts"
  type        = list
  default     = []
}

variable "allowed_egress_ips" {
  description = "An array of CIDRs allowed for egress traffic"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "manager_allowed_ports" {
  type = list
  default = [{
      "protocol"         = "tcp"
      "port_range_min"   = 80
      "port_range_max"   = 80
      "remote_ip_prefix" = "0.0.0.0/0"
    },
    {
      "protocol"         = "tcp"
      "port_range_min"   = 443
      "port_range_max"   = 443
      "remote_ip_prefix" = "0.0.0.0/0"
    }
  ]
}

#variable "lb_ip" {
#}

variable "lb_pool_method" {
  type        = string
  default     = "ROUND_ROBIN"
}

variable "lb_pool_protocol" {
  type        = string
  default     = "TCP"
}

variable "lb_listener_protocol" {
  type        = string
  default     = "TCP"
}
#variable "lb_member_address" {
#  type        = list(string)
#}

#variable "lb_subnet_id" {
#  type        = string
#}
