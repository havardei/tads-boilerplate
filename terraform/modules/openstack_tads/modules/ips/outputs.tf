output "manager_ips" {
  value = "${openstack_networking_floatingip_v2.manager[*].address}"
}
output "worker_ips" {
  value = "${openstack_networking_floatingip_v2.worker[*].address}"
}
output "lb_ip" {
  value = "${openstack_networking_floatingip_v2.lb[*].address}"
}