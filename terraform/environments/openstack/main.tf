
###
# Terraform openstack environment template
##

module "openstack_tads" {
  source = "../../modules/openstack_tads"
  public_key_path = ""
  project_name = "tads"
  number_of_managers = 1
  number_of_workers = 1
  flavor = ""
  external_net = ""
  network_name = "tads"
  floatingip_pool = ""
  worker_root_volume_size_in_gb = 80
  allowed_remote_ips = [""]
  image = ""
}
