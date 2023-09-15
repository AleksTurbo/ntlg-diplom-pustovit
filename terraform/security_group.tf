resource "yandex_vpc_security_group" "sec-grp" {
  name        = "netology-security-group"
  description = "netology security group"
  network_id  = "${var.lab_net_id}"

  ingress {
    protocol       = "TCP"
    description    = "ingress 80 WEB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ingress 3306 MySQL"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3306
  }

  ingress {
    protocol       = "TCP"
    description    = "ingress 9090 Prometheus"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9090
  }

    ingress {
    protocol       = "TCP"
    description    = "ingress 3000 GRAFANA"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3000
  }

  egress {
    protocol       = "ANY"
    description    = "egress"
    v4_cidr_blocks = ["192.168.0.0/16"]
    from_port      = 8090
    to_port        = 8099
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ICMP"
    description       = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 30000
    to_port           = 32767
  }
  egress {
    protocol          = "ANY"
    description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }

}

resource "yandex_vpc_security_group" "k8s-master-whitelist" {
  name        = "k8s-master-whitelist"
  description = "Правила группы разрешают доступ к API Kubernetes из интернета. Примените правила только к кластеру."
  network_id  = "${var.lab_net_id}"

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
    v4_cidr_blocks = ["178.155.12.9/32"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети."
    v4_cidr_blocks = ["178.155.12.9/32"]
    port           = 443
  }
}

