resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name               = "${var.project_name}-loadbalancer"
  #description        = var.lb_description
  vip_subnet_id      = var.lb_subnet_id
  #security_group_ids = var.lb_security_group_ids
  admin_state_up     = "true"
}

resource "openstack_lb_pool_v2" "lb_pool_http" {
  name            = "${var.project_name}-lb_pool_http"
  protocol        = "TCP"
  lb_method       = var.lb_pool_method
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "lb_pool_https" {
  name            = "${var.project_name}-lb_pool_https"
  protocol        = "TCP"
  lb_method       = var.lb_pool_method
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_listener_v2" "listener_http" {
  name                      = "${var.project_name}-listener-http"
  protocol                  = var.lb_listener_protocol
  protocol_port             = "80"
  admin_state_up            = "true"
  loadbalancer_id           = openstack_lb_loadbalancer_v2.loadbalancer.id
  default_pool_id           = openstack_lb_pool_v2.lb_pool_http.id
}

resource "openstack_lb_listener_v2" "listener_https" {
  name                      = "${var.project_name}-listener-https"
  protocol                  = var.lb_listener_protocol
  protocol_port             = "443"
  admin_state_up            = "true"
  loadbalancer_id           = openstack_lb_loadbalancer_v2.loadbalancer.id
  default_pool_id           = openstack_lb_pool_v2.lb_pool_https.id
}

resource "openstack_lb_monitor_v2" "lb_monitor_http" {
  name        = "${var.project_name}-lb_monitor_http"
  pool_id     = openstack_lb_pool_v2.lb_pool_http.id
  type        = var.lb_pool_protocol
  max_retries = var.lb_monitor_max_retries
  delay       = var.lb_monitor_delay
  timeout     = var.lb_monitor_timeout
}

resource "openstack_lb_monitor_v2" "lb_monitor_https" {
  name        = "${var.project_name}-lb_monitor_https"
  pool_id     = openstack_lb_pool_v2.lb_pool_https.id
  type        = var.lb_pool_protocol
  max_retries = var.lb_monitor_max_retries
  delay       = var.lb_monitor_delay
  timeout     = var.lb_monitor_timeout
}

resource "openstack_lb_member_v2" "member_http" {
  count         = length(var.lb_member_address)
  address       = element(var.lb_member_address, count.index)
  name          = "${var.project_name}-member-${element(var.lb_member_address, count.index)}"
  pool_id       = openstack_lb_pool_v2.lb_pool_http.id
  subnet_id     = var.lb_subnet_id
  protocol_port = "80"
}

resource "openstack_lb_member_v2" "member_https" {
  count         = length(var.lb_member_address)
  address       = element(var.lb_member_address, count.index)
  name          = "${var.project_name}-member-${element(var.lb_member_address, count.index)}"
  pool_id       = openstack_lb_pool_v2.lb_pool_https.id
  subnet_id     = var.lb_subnet_id
  protocol_port = 443
}

resource "openstack_networking_floatingip_associate_v2" "lb" {
  floating_ip           = var.lb_ip[0]
  port_id               = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}
