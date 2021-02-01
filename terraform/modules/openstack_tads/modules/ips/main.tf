resource "null_resource" "dummy_dependency" {
  triggers = {
    dependency_id = var.router_id
  }
}

resource "openstack_networking_floatingip_v2" "manager" {
  count      = var.number_of_managers
  pool       = var.floatingip_pool
  depends_on = [null_resource.dummy_dependency]
}
resource "openstack_networking_floatingip_v2" "worker" {
  count      = var.number_of_workers
  pool       = var.floatingip_pool
  depends_on = [null_resource.dummy_dependency]
}
