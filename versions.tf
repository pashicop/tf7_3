terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

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
}