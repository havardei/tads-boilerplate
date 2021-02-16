#output "elb_url" {
#  value = "${module.tads.elb_url}"
#}

output "ssh_user" {
  value = "${module.openstack_tads.ssh_user}"
}
output "manager_ips" {
  value = "${module.openstack_tads.manager_ips}"
}
output "worker_ips" {
  value = "${module.openstack_tads.worker_ips}"
}
output "lb_ip" {
  value = "${module.openstack_tads.lb_ip}"
}