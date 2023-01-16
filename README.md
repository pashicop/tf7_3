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





