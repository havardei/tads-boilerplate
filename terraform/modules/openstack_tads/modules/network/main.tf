resource "openstack_networking_router_v2" "router" {
  name                = "${var.project_name}-router"
  count               = var.use_neutron
  admin_state_up      = "true"
  external_network_id = var.external_net
}

resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  count          = var.use_neutron
  dns_domain     = null
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "${var.project_name}-internal-network"
  count           = var.use_neutron
  network_id      = openstack_networking_network_v2.network[count.index].id
  cidr            = var.subnet_cidr
  ip_version      = 4
}

resource "openstack_networking_router_interface_v2" "interface" {
  count     = var.use_neutron
  router_id = openstack_networking_router_v2.router[count.index].id
  subnet_id = openstack_networking_subnet_v2.subnet[count.index].id
}
