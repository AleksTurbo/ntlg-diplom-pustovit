# Network
resource "yandex_vpc_network" "subnet-zones" {
  name = "lab-net"
}

resource "yandex_vpc_subnet" "subnet-zones" {
  count          = 3
  name           = "subnet-${terraform.workspace}-${var.subnet-zones[count.index]}"
  zone           = "${var.subnet-zones[count.index]}"
  network_id     = "${yandex_vpc_network.subnet-zones.id}"
  v4_cidr_blocks = [ "${var.cidr.stage[count.index]}" ]
}
