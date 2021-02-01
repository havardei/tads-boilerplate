data "openstack_images_image_v2" "vm_image" {
  name = "${var.image}"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "keypair-${var.project_name}"
  public_key = chomp(file(var.public_key_path))
}


resource "openstack_networking_secgroup_v2" "manager" {
  name                 = "${var.project_name}-manager"
  description          = "${var.project_name} - manager"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "worker" {
  name                 = "${var.project_name}-worker"
  description          = "${var.project_name} - worker"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "swarm" {
  name                 = "${var.project_name}-swarm"
  description          = "${var.project_name} - swarm"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "internaltraffic" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.swarm.id
  security_group_id = openstack_networking_secgroup_v2.swarm.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh-swarm" {
  count             = length(var.allowed_remote_ips)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  remote_ip_prefix  = var.allowed_remote_ips[count.index]
  security_group_id = openstack_networking_secgroup_v2.swarm.id
}

resource "openstack_networking_secgroup_rule_v2" "egress-swarm" {
  count             = length(var.allowed_egress_ips)
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.allowed_egress_ips[count.index]
  security_group_id = openstack_networking_secgroup_v2.swarm.id
}


resource "openstack_networking_secgroup_rule_v2" "worker_allowed_ports" {
  count             = length(var.worker_allowed_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = lookup(var.worker_allowed_ports[count.index], "protocol", "tcp")
  port_range_min    = lookup(var.worker_allowed_ports[count.index], "port_range_min")
  port_range_max    = lookup(var.worker_allowed_ports[count.index], "port_range_max")
  remote_ip_prefix  = lookup(var.worker_allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")
  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_compute_instance_v2" "manager" {
  name              = "${var.project_name}-manager-${count.index+1}"
  count             = var.number_of_managers
  availability_zone = element(var.az_list, count.index)
  image_name        = var.image
  flavor_id         = var.flavor
  key_pair          = openstack_compute_keypair_v2.keypair.name

  network {
    name = var.network_name
  }

  security_groups = [openstack_networking_secgroup_v2.manager.name, openstack_networking_secgroup_v2.swarm.name]

  metadata = {
    ssh_user         = var.ssh_user
    depends_on       = var.network_id
  }

#  provisioner "local-exec" {
#  }
}

resource "openstack_compute_instance_v2" "worker" {
  name              = "${var.project_name}-worker-${count.index+1}"
  count             = var.worker_root_volume_size_in_gb == 0 ? var.number_of_workers : 0
  availability_zone = element(var.az_list, count.index)
  image_name        = var.image
  flavor_id         = var.flavor
  key_pair          = openstack_compute_keypair_v2.keypair.name

  network {
    name = var.network_name
  }

  security_groups = [openstack_networking_secgroup_v2.worker.name, openstack_networking_secgroup_v2.swarm.name]

  metadata = {
    ssh_user         = var.ssh_user
    depends_on       = var.network_id
  }

#  provisioner "local-exec" {
#  }
}



resource "openstack_compute_instance_v2" "worker_custom_volume_size" {
  name              = "${var.project_name}-worker-${count.index+1}"
  count             = var.worker_root_volume_size_in_gb > 0 ? var.number_of_workers : 0
  availability_zone = element(var.az_list, count.index)
  image_name        = var.image
  flavor_id         = var.flavor
  key_pair          = openstack_compute_keypair_v2.keypair.name

  block_device {
    uuid                  = data.openstack_images_image_v2.vm_image.id
    source_type           = "image"
    volume_size           = var.worker_root_volume_size_in_gb
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = var.network_name
  }

  security_groups = [openstack_networking_secgroup_v2.worker.name, openstack_networking_secgroup_v2.swarm.name]
  
  metadata = {
    ssh_user         = var.ssh_user
    depends_on       = var.network_id
  }
  
#  provisioner "local-exec" {
#  }
}

resource "openstack_compute_floatingip_associate_v2" "manager" {
  count                 = var.number_of_managers
  instance_id           = element(openstack_compute_instance_v2.manager.*.id, count.index)
  floating_ip           = var.manager_ips[count.index]
  wait_until_associated = var.wait_for_floatingip
}

resource "openstack_compute_floatingip_associate_v2" "worker" {
  count                 = var.worker_root_volume_size_in_gb == 0 ? var.number_of_workers : 0
  instance_id           = element(openstack_compute_instance_v2.worker.*.id, count.index)
  floating_ip           = var.worker_ips[count.index]
  wait_until_associated = var.wait_for_floatingip
}


resource "openstack_compute_floatingip_associate_v2" "worker_custom_volume_size" {
  count                 = var.worker_root_volume_size_in_gb > 0 ? var.number_of_workers : 0
  instance_id           = element(openstack_compute_instance_v2.worker_custom_volume_size.*.id, count.index)
  floating_ip           = var.worker_ips[count.index]
  wait_until_associated = var.wait_for_floatingip
}
