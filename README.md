# tf7_3
## Задача 1 
С помощью `yc cli` создал дополнительный сервис-аккаунт, добавил роль `editor`.  
Затем создал бакет через тот же `cli` и добавил бэкенд в `versions.tf`
```
backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "fb-netology"
    region     = "ru-central1"
    key        = "netology/tf_netology_7_3.tfstate"
    access_key = "YCAJEheuBfrKqTctQ-1CqAYag"
    secret_key = "YCNByeZ759Q_jb4mb7pj75VMZdoLKj1JABQG6HL9"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
```
`tfstate` в бакете после экспериментов
![bucket](https://user-images.githubusercontent.com/97126500/212778148-85263bf5-49cc-4ae0-ab8d-34a19651ac9b.png)

## Задача 2
Создал 2 воркспейса `prod` и `stage` и настроил количество ядер, памяти и количесто ВМ в зависимости от воркспейса через `count`.
```
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
  ```
  и добавил переменные:
  ```
  locals {
  cores = {
    default = 2
    stage   = 2
    prod    = 4
  }
  memory = {
    default = 4
    stage   = 4
    prod    = 8
  }
  count = {
    default = 1
    stage   = 1
    prod    = 2
  }
  ..
```
Cоздал ещё один ресурс и создаю кол-во машин через `for_each`:
```
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
  ..
```
и добавил переменную:
```
instances = {
    stage = {
      debian: 2,
    },
    prod = {
      debian: 4,
      debian2: 4,
    }
```
При этом ставлю количество ядер в каждой ВМ в зависимости от воркспейса.  
Пример при `stage`:
![stage](https://user-images.githubusercontent.com/97126500/212778692-e7ad5513-8d74-438e-88b8-7cc4d3be32b2.png)
Пример при `prod`:
![prod](https://user-images.githubusercontent.com/97126500/212778770-ee0ec230-2535-4fad-a1d4-23901c86311e.png)

Вывод `terraform workspace list` и `terraform plan` для `prod`:
```
pashi@pashi-docker:~/GolandProjects/tf7_3$ terraform workspace list
  default
* prod
  stage

pashi@pashi-docker:~/GolandProjects/tf7_3$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1[0] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv4gDcRYeuWKos4zvlntzdwJelAM82ucUpc3w4HjKjug92wF/Ohx6Jn7j6McDagRBd1nFgtV+3RW3WVb/1nZ3FbBOpaUKofiKFGO8Rj67PfTFdanT8bDjgvPA/n36RCrWj8HSJc+pggtCsp637vHEs8m3cgTw+FgZuFJkoZp9ri4aijMvbV6uwZ2tX2Vdl+O8oUe9wmEkGcxM3OdLiw/bmPAXdSH1m7D95OzXgM7UHBaHbRxzGvtPXvPH/xjZvkg6cUy24+d6SnBeRDOmAM3e75/TGyKrGbYH33qeCmUyc1wgPVBK3qwW5zeehi4vELOrGbDP5n42X54Hku3TgVPjdYwxKi5TMMlmMLEamtqPVj1UALW9jvRoZVeq05yxiUsWJSnv8sF463D62rUDH9jUjigLxHtSNKF6GMwZL5RCim0vaL5YPBBl4cmfYRrSENxUCmnqvyM8hWU+FXL/DirrGecvSJvh0AmpynEoOuqPSzwzn1B+ndzx7ex9S2JycDQs= pashi@pashi-docker
            EOT
        }
      + name                      = "tftest-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd82vol772l2nq9p12pb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1[1] will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv4gDcRYeuWKos4zvlntzdwJelAM82ucUpc3w4HjKjug92wF/Ohx6Jn7j6McDagRBd1nFgtV+3RW3WVb/1nZ3FbBOpaUKofiKFGO8Rj67PfTFdanT8bDjgvPA/n36RCrWj8HSJc+pggtCsp637vHEs8m3cgTw+FgZuFJkoZp9ri4aijMvbV6uwZ2tX2Vdl+O8oUe9wmEkGcxM3OdLiw/bmPAXdSH1m7D95OzXgM7UHBaHbRxzGvtPXvPH/xjZvkg6cUy24+d6SnBeRDOmAM3e75/TGyKrGbYH33qeCmUyc1wgPVBK3qwW5zeehi4vELOrGbDP5n42X54Hku3TgVPjdYwxKi5TMMlmMLEamtqPVj1UALW9jvRoZVeq05yxiUsWJSnv8sF463D62rUDH9jUjigLxHtSNKF6GMwZL5RCim0vaL5YPBBl4cmfYRrSENxUCmnqvyM8hWU+FXL/DirrGecvSJvh0AmpynEoOuqPSzwzn1B+ndzx7ex9S2JycDQs= pashi@pashi-docker
            EOT
        }
      + name                      = "tftest-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd82vol772l2nq9p12pb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["debian"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv4gDcRYeuWKos4zvlntzdwJelAM82ucUpc3w4HjKjug92wF/Ohx6Jn7j6McDagRBd1nFgtV+3RW3WVb/1nZ3FbBOpaUKofiKFGO8Rj67PfTFdanT8bDjgvPA/n36RCrWj8HSJc+pggtCsp637vHEs8m3cgTw+FgZuFJkoZp9ri4aijMvbV6uwZ2tX2Vdl+O8oUe9wmEkGcxM3OdLiw/bmPAXdSH1m7D95OzXgM7UHBaHbRxzGvtPXvPH/xjZvkg6cUy24+d6SnBeRDOmAM3e75/TGyKrGbYH33qeCmUyc1wgPVBK3qwW5zeehi4vELOrGbDP5n42X54Hku3TgVPjdYwxKi5TMMlmMLEamtqPVj1UALW9jvRoZVeq05yxiUsWJSnv8sF463D62rUDH9jUjigLxHtSNKF6GMwZL5RCim0vaL5YPBBl4cmfYRrSENxUCmnqvyM8hWU+FXL/DirrGecvSJvh0AmpynEoOuqPSzwzn1B+ndzx7ex9S2JycDQs= pashi@pashi-docker
            EOT
        }
      + name                      = "debian"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd82vol772l2nq9p12pb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-2["debian2"] will be created
  + resource "yandex_compute_instance" "vm-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                debian:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv4gDcRYeuWKos4zvlntzdwJelAM82ucUpc3w4HjKjug92wF/Ohx6Jn7j6McDagRBd1nFgtV+3RW3WVb/1nZ3FbBOpaUKofiKFGO8Rj67PfTFdanT8bDjgvPA/n36RCrWj8HSJc+pggtCsp637vHEs8m3cgTw+FgZuFJkoZp9ri4aijMvbV6uwZ2tX2Vdl+O8oUe9wmEkGcxM3OdLiw/bmPAXdSH1m7D95OzXgM7UHBaHbRxzGvtPXvPH/xjZvkg6cUy24+d6SnBeRDOmAM3e75/TGyKrGbYH33qeCmUyc1wgPVBK3qwW5zeehi4vELOrGbDP5n42X54Hku3TgVPjdYwxKi5TMMlmMLEamtqPVj1UALW9jvRoZVeq05yxiUsWJSnv8sF463D62rUDH9jUjigLxHtSNKF6GMwZL5RCim0vaL5YPBBl4cmfYRrSENxUCmnqvyM8hWU+FXL/DirrGecvSJvh0AmpynEoOuqPSzwzn1B+ndzx7ex9S2JycDQs= pashi@pashi-docker
            EOT
        }
      + name                      = "debian2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd82vol772l2nq9p12pb"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
pashi@pashi-docker:~/GolandProjects/tf7_3$ 

```




