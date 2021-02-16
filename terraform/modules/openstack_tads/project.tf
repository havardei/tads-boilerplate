provider "openstack" {
  version = "~> 1.17"
  use_octavia = true
}

module "network" {
  source = "./modules/network"

  external_net       = "${var.external_net}"
  network_name       = "${var.network_name}"
  subnet_cidr        = "${var.subnet_cidr}"
  project_name       = "${var.project_name}"
  use_neutron        = "${var.use_neutron}"
}

module "ips" {
  source = "./modules/ips"

  number_of_managers            = "${var.number_of_managers}"
  number_of_workers             = "${var.number_of_managers}"
  floatingip_pool               = "${var.floatingip_pool}"
  external_net                  = "${var.external_net}"
  network_name                  = "${var.network_name}"
  router_id                     = "${module.network.router_id}"
}

module "compute" {
  source = "./modules/compute"
  project_name                                 = "${var.project_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_managers                           = "${var.number_of_managers}"
  number_of_workers                            = "${var.number_of_workers}"
  worker_root_volume_size_in_gb                = "${var.worker_root_volume_size_in_gb}"
  public_key_path                              = "${var.public_key_path}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor                                       = "${var.flavor}"
  network_name                                 = "${var.network_name}"
  manager_ips                                  = "${module.ips.manager_ips}"
  worker_ips                                   = "${module.ips.worker_ips}"
  allowed_remote_ips                           = "${var.allowed_remote_ips}"
  allowed_egress_ips                           = "${var.allowed_egress_ips}"
  manager_allowed_ports                        = "${var.manager_allowed_ports}"
  wait_for_floatingip                          = "${var.wait_for_floatingip}"

  network_id = "${module.network.router_id}"
}

module "lb" {
  source = "./modules/lb"
  project_name        = "${var.project_name}"
  lb_ip               = "${module.ips.lb_ip}"
  lb_subnet_id        = "${module.network.subnet_id}"
  lb_member_address      = "${module.ips.manager_ips}"
  wait_for_floatingip = "${var.wait_for_floatingip}"
}


output "ssh_user" {
  value = "${var.ssh_user}"
}
output "manager_ips" {
  value = "${module.ips.manager_ips}"
}
output "worker_ips" {
  value = "${module.ips.worker_ips}"
}
output "lb_ip" {
  value = "${module.ips.lb_ip}"
}
