variable "yandex_cloud_id" {
  default = "b1gk0tcpmdt9lhdnsjrl"
}

variable "yandex_folder_id" {
  default = "b1g1qalus625i26qmq56"
}

variable "instance-nat-ip" {
  default = "192.168.10.254"
}

variable "domain" {
  default = "netology.ycloud"
}

variable "user_name" {
  description = "instance User Name"
  default     = "ubuntu"
}

variable "user_ssh_key_path" {
  description = "User's SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ubuntu-2004-lts" {
  default = "fd8pqclrbi85ektgehlf"
}

variable "a-zone" {
  default = "ru-central1-a"
}

variable "subnet-zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "cidr" {
  type    = map(list(string))
  default = {
    stage = ["10.10.10.0/24", "10.10.20.0/24", "10.10.30.0/24"]    
  }
}