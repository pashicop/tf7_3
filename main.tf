provider "yandex" {
  token = var.YC_TOKEN
#  service_account_key_file = ""
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "tftest-${count.index}"
  count = local.count[terraform.workspace]

  resources {
    cores  = local.cores[terraform.workspace]
    memory = local.memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "fd82vol772l2nq9p12pb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "debian:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  for_each = local.instances[terraform.workspace]
  name = "${each.key}"
#  inst_count = each.value
  resources {
    cores  = each.value
    memory = local.memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "fd82vol772l2nq9p12pb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "debian:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#output "internal_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
#}
#
#
#output "external_ip_address_vm_1" {
#  value = yandex_compute_instance.vm-1[count.index].network_interface.0.nat_ip_address
#}
