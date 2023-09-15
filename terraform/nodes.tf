resource "yandex_compute_instance" "cluster-k8s" {  
  count   = 3
  name                      = "${terraform.workspace}-node-${count.index}"
  zone                      = "${var.subnet-zones[count.index]}"
  hostname                  = "${terraform.workspace}-node-${count.index}"
  allow_stopping_for_update = true
  labels = {index = "${terraform.workspace}-node-${count.index}"} 
 
  scheduling_policy {
    preemptible = false
  }

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-2004-lts}"
      type        = "network-ssd"
      size        = "20"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.subnet-zones[count.index].id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "${var.user_name}:${file("~/.ssh/id_rsa.pub")}"
  }       
}

// Create inventory for KubeSpray
resource "local_file" "inventory" {
  count   = 3
  content  = <<EOT
[all]
node1 ansible_host=${yandex_compute_instance.cluster-k8s[0].network_interface.0.nat_ip_address}
node2 ansible_host=${yandex_compute_instance.cluster-k8s[1].network_interface.0.nat_ip_address}
node3 ansible_host=${yandex_compute_instance.cluster-k8s[2].network_interface.0.nat_ip_address}

[kube_control_plane]
node1

[etcd]
node1

[kube_node]
node2
node3

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
EOT
  filename = "../kubespray/inventory/inventory.ini"
}