terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "=0.138.0"
    }
  }
}

locals {
  folder_id = "folder_id"
  cloud_id  = "cloud_id"
}

provider "yandex" {
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "./authorized_key.json"
}