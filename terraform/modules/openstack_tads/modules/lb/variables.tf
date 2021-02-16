variable "project_name" {}

variable "wait_for_floatingip" {}

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
variable "lb_member_address" {
  type        = list(string)
}

variable "lb_subnet_id" {
  type        = string
}

variable "lb_ip" {
  type = list
}

variable "lb_monitor_delay" {
  type        = string
  default     = "20"
}

variable "lb_monitor_timeout" {
  type        = string
  default     = "10"
}

variable "lb_monitor_max_retries" {
  type        = string
  default     = "5"
}